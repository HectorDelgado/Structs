//
//  SinglyLinkedList.swift
//  DynamicDataStructures
//
//  Created by Hector Delgado on 10/20/21.
//

import Foundation

/**
 This is a simple implementation of a singly linked list.
 */
public struct SinglyLinkedList<T> {
    
    //MARK: - Properties
    
    enum SLLError: Error {
        case OutOfBoundsError(description: String)
        case EmptyListError(description: String)
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
     Initializes an empty list with the head node set to nil.
     */
    public init() {}
    
    /**
     Initializes the list with the head node containing the given value.
     - Parameter data: The data to initialize the list with.
     */
    public init(data: T) {
        head = SLLNode(data: data)
        count += 1
    }
    
    //MARK: - Insertion
    
    /**
     Inserts a node at the end of the list.
     - Parameter data: The element to insert into the list.
     */
    public mutating func append(_ data: T) {
        guard head != nil else {
            push(data)
            return
        }
        copyNodes()
        
        var lastNode = head
        while lastNode?.next != nil {
            lastNode = lastNode?.next
        }
        
        lastNode!.next = SLLNode(data: data)
        count += 1
    }
    
    /**
     Inserts a node before the given position.
     - Parameters:
        - data: The data to insert into the list.
        - position: The position to insert a new element into the list.
     */
    public mutating func insert(_ data: T, beforeIndex position: Int) throws {
        try checkIndex(at: position)
        if position == 0 {
            push(data)
        } else {
            if let previousNode = getNode(at: position - 1) {
                copyNodes()
                previousNode.next = SLLNode(data: data, next: previousNode.next)
                count += 1
            }
        }
    }
    
    /**
     Inserts a node after the given position.
     - Parameters:
        - data: The element to insert into the list.
        - position: The index to insert the element at.
     - Throws: `SLLError.IndexOutOfBoundsError`
     */
    public mutating func insert(_ data: T, afterIndex position: Int) throws {
        try checkIndex(at: position)
        if position == count - 1 {
            append(data)
        } else {
            if let targetNode = getNode(at: position) {
                copyNodes()
                targetNode.next = SLLNode(data: data, next: targetNode.next)
                count += 1
            }
        }
    }
    
    /**
     Inserts a new node at the beginning of the list.
     - Parameter data: The element to insert into the list.
     */
    public mutating func push(_ data: T) {
        copyNodes()
        head = SLLNode(data: data, next: head)
        count += 1
    }
    
    //MARK: - Deletion
    
    /**
     Removes the node at the given position.
     - Parameter position: The index to remove an element at.
     - Returns: The element that was removed from the list.
     */
    @discardableResult
    public mutating func remove(at position: Int) throws -> T? {
        try checkIndex(at: position)
        if position == 0 {
            return removeFirst()
        } else {
            copyNodes()
            var previousNode = head
            var currentNode = head?.next
            var currentIndex = 1
            
            while currentIndex != position {
                previousNode = currentNode
                currentNode = currentNode?.next
                currentIndex += 1
            }
            
            let temp = currentNode
            previousNode?.next = currentNode?.next
            return temp?.data
        }
    }
    
    /**
     Removes the first node in the list.
     - Returns: The first element that was removed.
     */
    @discardableResult
    public mutating func removeFirst() -> T? {
        guard head != nil else {
            return nil
        }
        
        copyNodes()
        let temp = head
        head = head?.next
        return temp?.data
    }
    
    /**
     Clears all nodes in the list.
     */
    public mutating func clear() {
        copyNodes()
        head = nil
        count = 0
    }
    
    //MARK: - Search/Retrieval
    
    /**
     Searches for the returns the node at the given position.
     - Parameter position: The position of the node to retrieve from the list.
     - Returns: The node at the given position, or nil.
     */
    private func getNode(at position: Int) -> SLLNode<T>? {
        var currentNode = head
        var currentIndex = 0
        
        while currentNode != nil {
            if currentIndex == position {
                return currentNode
            }
            currentNode = currentNode?.next
            currentIndex += 1
        }
        
        return nil
    }
    
    //MARK: - Utility
    
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

//MARK: - T: Equatable extensions

extension SinglyLinkedList where T: Equatable {
    
    //MARK: - Insertion
    
    /**
     Inserts a node after the target data.
     - Parameters:
        - data: The data to insert into the list.
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
     Inserts a node before the target data.
     - Parameters:
        - data: The data to insert into the list.
        - previousData: The element to insert data before.
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
    
    //MARK: - Deletion
    
    /**
     Removes the node with the given data from the list.
     - Parameter data: The element to remove from the list.
     - Returns: The element that was removed from the list, or nil if does not exist.
     */
    @discardableResult
    public mutating func remove(_ data: T) -> T? {
        guard head != nil else {
            return nil
        }
        
        let targetIndex = indexOf(data: data)
        
        do {
            return try remove(at: targetIndex)
        } catch {
            return nil
        }
    }
    
    //MARK: - Search/Retrieval
    
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
     Returns true if the list contains the item.
     - Parameter data: The element to search for.
     - Returns: True if the item exists in the list.
     */
    public func contains(_ data: T) -> Bool {
        return indexOf(data: data) >= 0
    }
}


//MARK: - CustomStringConvertable extension

extension SinglyLinkedList: CustomStringConvertible {
    public var description: String {
        var currentNode = head
        var desc = "Head ["
        
        while currentNode != nil {
            desc += "\(currentNode!.data)"
            if currentNode?.next != nil {
                desc += "->"
            }
            currentNode = currentNode?.next
        }
        
        desc += "]"
        return desc
    }
}

//MARK: - ExpressiblyByArrayLiteral extension
extension SinglyLinkedList: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        let newHead = SLLNode(data: elements.first!)
        var tempHead = newHead.next
        
        for i in 1..<elements.count {
            tempHead = SLLNode(data: elements[i])
            tempHead = tempHead?.next
        }
        head = newHead
        count = elements.count
    }
}
