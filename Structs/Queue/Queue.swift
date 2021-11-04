//
//  Queue.swift
//  Structs
//
//  Created by Hector Delgado on 11/4/21.
//

import Foundation

protocol Queue {
    associatedtype T: Equatable
    var isEmpty: Bool { get }
    var peek: T? { get }
    mutating func enqueue(_ data: T) -> Bool
    mutating func dequeue() -> T?
}
