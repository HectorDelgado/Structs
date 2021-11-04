//
//  DLLNode.swift
//  DynamicDataStructures
//
//  Created by Hector Delgado on 10/22/21.
//

import Foundation

/**
 Represents a node in a doubly linked list which contains data, a reference
 to the previous node, and a reference to the next node.
 */
final class DLLNode<T: Comparable> {
    /// The data stored in the node.
    var data: T
    
    /// A weak reference to the previous node.
    weak var prev: DLLNode<T>?
    
    /// A reference to the next node.
    var next: DLLNode<T>?
    
    /**
     Initializes a DLLNode with the given data, a previous reference and next reference.
     - Parameters:
        - data: The data to set for the node.
        - prev: A reference to the previous node.
        - next: A reference to the next node.
     */
    init(data: T, prev: DLLNode<T>? = nil, next: DLLNode<T>? = nil) {
        self.data = data
        self.prev = prev
        self.next = next
    }
}

//MARK: - Equatable

extension DLLNode: Equatable {
    static func ==(lhs: DLLNode<T>, rhs: DLLNode<T>) -> Bool {
        return lhs.data == rhs.data
    }
}

//MARK: - CustomStringConvertable

extension DLLNode: CustomStringConvertible {
    public var description: String {
        return "\(data)"
    }
}
