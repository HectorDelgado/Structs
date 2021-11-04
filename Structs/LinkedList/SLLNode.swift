//
//  SLLNode.swift
//  DynamicDataStructures
//
//  Created by Hector Delgado on 10/20/21.
//
import Foundation

/**
 Represents a node in a singly linked list which contains data and
 a reference to the next node.
 */
final public class SLLNode<T: Comparable> {
    var data: T
    var next: SLLNode<T>?
    
    /**
     Initializes a SLLNode with the given data and a next reference.
     - Parameters:
        - data: The data to set for the node.
        - next: A reference to the next node.
     */
    public init(data: T, next: SLLNode<T>? = nil) {
        self.data = data
        self.next = next
    }
}

extension SLLNode: Equatable {
    public static func == (lhs: SLLNode<T>, rhs: SLLNode<T>) -> Bool {
        return lhs.data == rhs.data
    }
}

extension SLLNode: CustomStringConvertible {
    public var description: String {
        return "\(data)"
    }
}
