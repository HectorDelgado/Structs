//
//  SLLNode.swift
//  DynamicDataStructures
//
//  Created by Hector Delgado on 10/20/21.
//
import Foundation

final class SLLNode<T> {
    var data: T
    var next: SLLNode<T>?
    
    init(data: T, next: SLLNode<T>? = nil) {
        self.data = data
        self.next = next
    }
}

extension SLLNode: Equatable where T: Equatable {
    static func == (lhs: SLLNode<T>, rhs: SLLNode<T>) -> Bool {
        return lhs.data == rhs.data
    }
}
