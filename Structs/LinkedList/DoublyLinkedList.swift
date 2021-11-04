//
//  DoublyLinkedList.swift
//  DynamicDataStructures
//
//  Created by Hector Delgado on 10/22/21.
//

import Foundation

/**
 An implementation of a doubly linked list that provides quick
 insertions & deletions at both the front and end of the list.
 */
public struct DoublyLinkedList<T: Comparable> {
    
    //MARK: - Properties
    
    enum DLLError: Error {
        case OutOfBoundsError(description: String)
    }
    
    private var head: DLLNode<T>?
    
    private var tail: DLLNode<T>?
    
    public private(set) var count = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var first: T? {
        return head?.data
    }
    
    public var last: T? {
        return tail?.data
    }
    
    //MARK: - Constructors
    
    /**
     Initializes an empty linked list.
     */
    public init() {}
    
    /**
     Initializes the linked list with the given data as the first and last element.
     - Parameter data: The data to initialize the list with.
     */
    public init(data: T) {
        head = DLLNode(data: data)
        tail = head
        count += 1
    }
    
    /**
     Initializes the linked list from the given sequence of elements.
     - Parameter sequence: A sequence of values to create the list from.
     */
    public init<S: Sequence>(_ sequence: S) where
        S.Iterator.Element == T {
        var tempList = DoublyLinkedList<T>()
        
        for element in sequence {
            tempList.append(element)
        }
        
        self.head = tempList.head
        self.tail = tempList.tail
        self.count = tempList.count
    }
    
    

    
    
    
    
    
}

//MARK: - Insertion

extension DoublyLinkedList {
    /**
     Inserts an element at the beginning of the list.
     - Parameter data: The element to insert into the list.
     */
    public mutating func push(_ data: T) {
        copyNodes()
        head = DLLNode(data: data, prev: nil, next: head)
        if tail == nil {
            tail = head
        }
        count += 1
    }
    
    /**
     Inserts an element at the end of the list.
     - Parameter data: The element to insert into the list.
     */
    public mutating func append(_ data: T) {
        guard head != nil else {
            push(data)
            return
        }
        
        copyNodes()
        let newNode = DLLNode(data: data, prev: tail)
        tail!.next = newNode
        tail = newNode
        count += 1
    }
    
    /**
     Inserts the given element before the target element if it exist in the list.
     - Parameters:
        - data: The element to insert into the list.
        - targetData: The element to insert to insert the new element before.
     - Returns: True if the element was successfully added to the list, false otherwise.
     */
    @discardableResult
    public mutating func insert(_ data: T, before targetData: T) -> Bool {
        guard head != nil else {
            return false
        }
        if head!.data == targetData {
            push(data)
            return true
        } else {
            if let previousNode = getNode(before: targetData) {
                copyNodes()
                let newNode = DLLNode(data: data, prev: previousNode, next: previousNode.next)
                previousNode.next?.prev = newNode
                previousNode.next = newNode
                count += 1
                return true
            } else {
                return false
            }
        }
    }
    
    /**
     Inserts the given element after the target element if it exist in the list.
     - Parameters:
        - data: The element to insert into the list.
        - targetData: The element to insert data after.
     - Returns: True if the element was successfully added to the list, false otherwise.
     */
    @discardableResult
    public mutating func insert(_ data: T, after targetData: T) -> Bool {
        guard head != nil else {
            return false
        }
        
        if tail!.data == targetData {
            append(data)
            return true
        } else {
            if let targetNode = getNode(with: targetData) {
                copyNodes()
                let newNode = DLLNode(data: data, prev: targetNode, next: targetNode.next)
                targetNode.next?.prev = newNode
                targetNode.next = newNode
                count += 1
                return true
            } else {
                return false
            }
        }
    }
    
    /**
     Inserts the given element before the given position in the list.
     - Parameters:
        - data: The element to insert into the list.
        - index: The position to insert a new element into the list.
     - Precondition: `index` must be non-negative and less than `count` - 1.
     - Throws: `DLLError.OutOfBoundsError`
     */
    public mutating func insert(_ data: T, beforeIndex index: Int) throws {
        try checkIndex(at: index)
        if index == 0 {
            push(data)
        } else {
            if let previousNode = getNode(at: index - 1) {
                copyNodes()
                let newNode = DLLNode(data: data, prev: previousNode, next: previousNode.next)
                previousNode.next?.prev = newNode
                previousNode.next = newNode
                count += 1
            }
        }
    }
    
    /**
     Inserts the given element after the given position in the list.
     - Parameters:
        - data: The element to insert into the list.
        - index: The position to insert a new element into the list.
     - Precondition: `index` must be non-negative and less than `count` - 1.
     - Throws: `DLLError.OutOfBoundsError`
     */
    public mutating func insert(_ data: T, afterIndex index: Int) throws {
        try checkIndex(at: index)
        if index == count - 1 {
            append(data)
        } else {
            if let targetNode = getNode(at: index) {
                copyNodes()
                let newNode = DLLNode(data: data, prev: targetNode, next: targetNode.next)
                targetNode.next?.prev = newNode
                targetNode.next = newNode
                count += 1
            }
        }
    }
}

//MARK: - Deletion

extension DoublyLinkedList {
    /**
     Removes the element at the given index.
     - Parameter index: The index to remove an element at.
     - Precondition: `index` must be non-negative and less than `count` - 1.
     - Throws: `SLLError.IndexOutOfBoundsError`
     - Returns: The element that was removed from the list.
     */
    @discardableResult
    public mutating func remove(at index: Int) throws -> T {
        try checkIndex(at: index)
        if index == 0 {
            return removeFirst()!
        } else if index == count - 1 {
            return removeLast()!
        } else {
            copyNodes()
            let targertNode = getNode(at: index)!
            targertNode.prev?.next = targertNode.next
            targertNode.next?.prev = targertNode.prev
            count -= 1
            return targertNode.data
        }
    }
    
    /**
     Removes the element with the given data from the list.
     - Parameter data: The element to removed from the list.
     - Returns: The element that was removed from the list, or nil if it does not exist.
     */
    @discardableResult
    public mutating func remove(_ data: T) -> T? {
        guard head != nil else {
            return nil
        }
        
        if head!.data == data {
            return removeFirst()
        } else if tail!.data == data {
            return removeLast()
        } else {
            if let targetNode = getNode(with: data) {
                copyNodes()
                targetNode.prev?.next = targetNode.next
                targetNode.next?.prev = targetNode.prev
                count -= 1
                return targetNode.data
            } else {
                return nil
            }
        }
    }
    
    /**
     Removes the first element in the list.
     - Returns: The first element in the list, or nil if the list is empty.
     */
    @discardableResult
    public mutating func removeFirst() -> T? {
        copyNodes()
        let temp = head
        head?.next?.prev = nil
        head = head?.next
        count -= 1
        return temp?.data
    }
    
    /**
     Removes the last element in the list.
     - Returns: The last element in the list, or nil if the list is empty.
     */
    public mutating func removeLast() -> T? {
        copyNodes()
        let temp = tail
        tail?.prev?.next = nil
        tail = tail?.prev
        count -= 1
        return temp?.data
    }
    
    /**
     Removes all elements in the list.
     */
    public mutating func clear() {
        copyNodes()
        head = nil
        tail = nil
        count = 0
    }
}

//MARK: - Search/Retrieval
extension DoublyLinkedList {
    /**
     Searches for the returns the node at the given position.
     - Parameter index: The position of the node to retrieve from the list.
     - Returns: The node at the given position, or nil.
     */
    private func getNode(at index: Int) -> DLLNode<T>? {
        var currentNode = head
        var currentIndex = 0
        while currentNode != nil {
            if currentIndex == index {
                return currentNode
            }
            currentNode = currentNode?.next
            currentIndex += 1
        }
        return nil
    }
    
    /**
     Searches for and returns the first node that contains the given data.
     - Parameter data: The data to search for.
     - Returns: The first node that contains the given data if it exist, or nil.
     */
    private func getNode(with data: T) -> DLLNode<T>? {
        var currentNode = head
        
        while currentNode != nil {
            if currentNode!.data == data {
                return currentNode
            }
            currentNode = currentNode?.next
        }
        return nil
    }
    
    /**
     Searches for and returns the first node before the node with the given data.
     - Parameter data: The data to search for.
     - Returns: The first node before the node that contains the given data if it exist, or nill
     */
    private func getNode(before data: T) -> DLLNode<T>? {
        var previousNode = head
        
        while let currentNode = previousNode?.next {
            if currentNode.data == data {
                return previousNode
            }
            previousNode = previousNode?.next
        }
        return nil
    }
    
    /**
     Searches for and returns the index of the element in the list.
     - Parameter data: The element to search for.
     - Returns: The index the item is located at, or -1 if it does not exists.
     */
    public func indexOf(data: T) -> Int {
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil {
            if currentNode!.data == data {
                return currentIndex
            }
            currentNode = currentNode?.next
            currentIndex += 1
        }
        
        return -1
    }
}

//MARK: - Utility

extension DoublyLinkedList {
    private func checkIndex(at position: Int) throws {
        if !indexIsValid(at: position) {
            throw DLLError.OutOfBoundsError(description: "Out of bounds exception. Position \(position) with size of \(count).")
        }
    }
    
    private func indexIsValid(at position: Int) -> Bool {
        if position < 0 || position > count - 1 {
            return false
        }
        return true
    }
    
    /**
     Copies the values of all nodes from the list if the head node is not uniquely referenced.
     */
    private mutating func copyNodes() {
        guard !isKnownUniquelyReferenced(&head) else {
            return
        }
        guard head != nil else {
            return
        }
        
        var tempList = DoublyLinkedList<T>()
        tempList.append(head!.data)
        
        while let nextNode = head?.next {
            tempList.append(nextNode.data)
        }
        head = tempList.head
    }
}

//MARK: - CustomStringConvertable

extension DoublyLinkedList: CustomStringConvertible {
    public var description: String {
        var currentNode = head
        var desc = "Head ["
        
        while currentNode != nil {
            desc += "\(currentNode!)"
            if currentNode?.next != nil {
                desc += "<->"
            }
            currentNode = currentNode?.next
        }
        
        return desc + "] Tail"
    }
}

//MARK: - ExpressiblyByArrayLiteral

extension DoublyLinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init()
        elements.forEach{ append($0) }
    }
}

//MARK: - Sequence & IteratorProtocol

extension DoublyLinkedList: Sequence, IteratorProtocol {
    public mutating func next() -> T? {
        defer {
            head = head?.next
        }
        return head?.data
    }
}

//MARK: - Subscript

extension DoublyLinkedList {
    public subscript(index: Int) -> T {
        return getNode(at: index)!.data
    }
}

