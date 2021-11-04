//
//  SinglyLinkedList.swift
//  DynamicDataStructures
//
//  Created by Hector Delgado on 10/20/21.
//

import Foundation

/**
 An implementation of a singly linked list that provides quick
 insertions & deletions at the front of the list.
 */
public struct SinglyLinkedList<T: Comparable> {
    
    //MARK: - Properties
    
    enum SLLError: Error {
        case OutOfBoundsError(description: String)
    }
    
    private var head: SLLNode<T>?
    
    public private(set) var count = 0
    
    public var isEmpty: Bool {
        return count == 0
    }
    
    public var first: T? {
        return head?.data
    }
    
    //MARK: - Constructors
    
    /**
     Initializes an empty linked list.
     */
    public init() {}
    
    /**
     Initializes the linked list with the given data as the first element.
     - Parameter data: The data to initialize the list with.
     */
    public init(data: T) {
        head = SLLNode(data: data)
        count += 1
    }
    
    /**
     Initializes the linked list from the given sequence of elements.
     - Parameter sequence: A sequene of valules to create the list form.
     */
    public init<S: Sequence>(_ sequence: S) where
        S.Iterator.Element == T {
        var tempList = SinglyLinkedList<T>()
        
        for element in sequence {
            tempList.append(element)
        }
        
        self.head = tempList.head
        self.count = tempList.count
    }
}

//MARK: - Insertion

extension SinglyLinkedList {
    /**
     Inserts an element at the beginning of the list.
     - Parameter data: The element to insert into the list.
     */
    public mutating func push(_ data: T) {
        copyNodes()
        head = SLLNode(data: data, next: head)
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
        getLastNode()!.next = SLLNode(data: data)
        count += 1
    }
    
    /**
     Inserts the given element before the target element if it exist in the list.
     - Parameters:
        - data: The element to insert into the list.
        - targetData: The element to insert the new element before.
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
                previousNode.next = SLLNode(data: data, next: previousNode.next)
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
        
        if let targetNode = getNode(with: targetData) {
            copyNodes()
            targetNode.next = SLLNode(data: data, next: targetNode.next)
            count += 1
            return true
        } else {
            return false
        }
    }
    
    /**
     Inserts the given element before the given index in the list.
     - Parameters:
        - data: The element to insert into the list.
        - index: The position to insert a new element into the list.
     - Precondition: `index` must be non-negative and less than `count` - 1.
     - Throws: `SLLError.OutOfBoundsError`
     */
    public mutating func insert(_ data: T, beforeIndex index: Int) throws {
        try checkIndex(at: index)
        if index == 0 {
            push(data)
        } else {
            if let previousNode = getNode(at: index - 1) {
                copyNodes()
                previousNode.next = SLLNode(data: data, next: previousNode.next)
                count += 1
            }
        }
    }
    
    /**
     Inserts the given element after the given index in the list.
     - Parameters:
        - data: The element to insert into the list.
        - position: The index to insert the element at.
     - Precondition: `index` must be non-negative and less than `count` - 1.
     - Throws: `SLLError.IndexOutOfBoundsError`
     */
    public mutating func insert(_ data: T, afterIndex index: Int) throws {
        try checkIndex(at: index)
        if index == count - 1 {
            append(data)
        } else {
            if let targetNode = getNode(at: index) {
                copyNodes()
                targetNode.next = SLLNode(data: data, next: targetNode.next)
                count += 1
            }
        }
    }
}

//MARK: - Deletion

extension SinglyLinkedList {
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
        } else {
            copyNodes()
            let previousNode = getNode(at: index - 1)!
            let targetNode = previousNode.next!
            previousNode.next = targetNode.next
            count -= 1
            return targetNode.data
        }
    }
    
    /**
     Removes the element with the given data from the list.
     - Parameter data: The element to remove from the list.
     - Returns: The element that was removed from the list, or nil if does not exist.
     */
    @discardableResult
    public mutating func remove(_ data: T) -> T? {
        guard head != nil else {
            return nil
        }
        
        if head!.data == data {
            return removeFirst()
        } else {
            let previousNode = head
            while let targetNode = previousNode?.next {
                if targetNode.data == data {
                    copyNodes()
                    previousNode?.next = targetNode.next
                    count -= 1
                    return targetNode.data
                }
            }
            return nil
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
        head = head?.next
        count -= 1
        return temp?.data
    }
    
    /**
     Removes all elements in the list.
     */
    public mutating func clear() {
        copyNodes()
        head = nil
        count = 0
    }
}

//MARK: - Search/Retrieval

extension SinglyLinkedList {
    /**
     Searches for and returns the node at the given position.
     - Parameter index: The position of the node to retrieve from the list.
     - Returns: The node at the given position, or nil.
     */
    private func getNode(at index: Int) -> SLLNode<T>? {
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
    private func getNode(with data: T) -> SLLNode<T>? {
        var currentNode = head
        
        while currentNode != nil {
            if currentNode?.data == data {
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
    private func getNode(before data: T) -> SLLNode<T>? {
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
            if currentNode?.data == data {
                return currentIndex
            }
            currentNode = currentNode?.next
            currentIndex += 1
        }
        
        return -1
    }
    
    /**
     Returns the last node in the list.
     - Returns: The last node in the list, or nil if the list is empty.
     */
    private func getLastNode() -> SLLNode<T>? {
        var currentNode = head
        
        while currentNode?.next != nil {
            currentNode = currentNode?.next
        }
        
        return currentNode
    }
    
    /**
     Returns true if the list contains the item.
     - Parameter data: The element to search for.
     - Returns: True if the item exists in the list.
     */
    public func contains(_ data: T) -> Bool {
        guard head != nil else {
            return false
        }
        if head!.data == data {
            return true
        }
        return indexOf(data: data) >= 0
    }
}

//MARK: - Utility

extension SinglyLinkedList {
    private func checkIndex(at position: Int) throws {
        if !indexIsValid(at: position) {
            throw SLLError.OutOfBoundsError(description: "Out of bounds exception. Position \(position) with size of \(count)")
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
        guard var oldNode = head else {
            return
        }
        head = SLLNode(data: oldNode.data)
        var newNode = head
        
        while let nextOldNode = oldNode.next {
            newNode!.next = SLLNode(data: nextOldNode.data)
            newNode = nextOldNode
            oldNode = nextOldNode
        }
    }
}

//MARK: - Equatable

extension SinglyLinkedList: Equatable {
    public static func ==(lhs: SinglyLinkedList, rhs: SinglyLinkedList) -> Bool {
        guard lhs.count == rhs.count else {
            return false
        }
        
        for (left, right) in zip(lhs, rhs) {
            if left != right {
                return false
            }
        }
        return true
    }
}

//MARK: - CustomStringConvertable

extension SinglyLinkedList: CustomStringConvertible {
    public var description: String {
        var currentNode = head
        var desc = "Head ["
        
        while currentNode != nil {
            desc += "\(currentNode!)"
            if currentNode?.next != nil {
                desc += "->"
            }
            currentNode = currentNode?.next
        }
        
        return desc + "]"
    }
}

//MARK: - ExpressiblyByArrayLiteral

extension SinglyLinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init()
        elements.forEach { append($0) }
    }
}

//MARK: - Sequence & IteratorProtocol

extension SinglyLinkedList: Sequence, IteratorProtocol {
    public mutating func next() -> T? {
        defer {
            head = head?.next
        }
        return head?.data
    }
}

//MARK: - Subscript

extension SinglyLinkedList {
    public subscript(index: Int) -> T {
        return getNode(at: index)!.data
    }
}

