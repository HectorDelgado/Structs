//
//  QueueLinkedList.swift
//  Structs
//
//  Created by Hector Delgado on 11/4/21.
//

import Foundation

/**
 An implementation of a Queue using a DoublyLinkedList to store elements.
 */
public struct QueueLinkedList<T: Comparable>: Queue {
    /// Strores the elements in the queue.
    private var elements = DoublyLinkedList<T>()
    
    /// Returns true if the queue is empty.
    public var isEmpty: Bool {
        return elements.isEmpty
    }
    
    /// Returns the element at the front of the queue.
    public var peek: T? {
        return elements.first
    }
    
    /// Returns the number of elements in teh queue.
    public var count: Int {
        return elements.count
    }
    
    /**
     Initializes an empty queue.
     */
    public init() { }
    
    /**
     Initializes a queue with the given element as the first element.
     - Parameter element: The element to set as the first element.
     */
    public init(_ element: T) {
        enqueue(element)
    }
    
    /**
     Initializes a queue with the values from the given sequence.
     - Parameter sequence: The sequence of elements to initialze the queue from.
     */
    public init<S: Sequence>(_ sequence: S) where
        S.Iterator.Element == T {
        for element in sequence {
            enqueue(element)
        }
    }
    
    /**
     Inserts an element at the back of the queue.
     - Parameter element: The element to add to the queue.
     - Returns: True if the element was succesfully
     */
    @discardableResult
    public mutating func enqueue(_ element: T) -> Bool {
        elements.append(element)
        return true
    }
    
    /**
     Removes the element at the front of the queue.
     - Returns: The element at the front of the queue, or nil if the list is empty.
     */
    @discardableResult
    public mutating func dequeue() -> T? {
        return isEmpty ? nil : elements.removeFirst()
    }
}

//MARK: - CustomStringConvertible

extension QueueLinkedList: CustomStringConvertible {
    public var description: String {
        var elem = ""
        for e in elements {
            elem += "\(e) "
        }
        return "Front [" + elem + "] Rear"
    }
}

//MARK: - Equatable

extension QueueLinkedList: Equatable {
    public static func ==(lhs: QueueLinkedList<T>, rhs: QueueLinkedList<T>) -> Bool {
        return lhs.elements == rhs.elements
    }
}
