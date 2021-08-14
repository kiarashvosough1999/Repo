//
//  Queue.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

internal struct Queue<T>:Collection {
    
    typealias Element = T
    typealias Index = Int
    
    private var elements: [T] = []
    
    mutating func enqueue(_ value: T) {
        elements.append(value)
    }
    
    @discardableResult
    internal mutating func dequeue() -> T? {
        guard !elements.isEmpty else {
            return nil
        }
        return elements.removeFirst()
    }
    
    // The upper and lower bounds of the collection, used in iterations
    var startIndex: Index { elements.startIndex }
    var endIndex: Index { elements.endIndex }
    
    // Required subscript, based on a dictionary index
    subscript(index: Index) -> T {
        get { return elements[index] }
    }
    
    // Method that returns the next index when iterating
    func index(after i: Index) -> Index {
        return elements.index(after: i)
    }
    
    var head: T? {
        return elements.first
    }
    
    var tail: T? {
        return elements.last
    }
}

infix operator <- : AssignmentPrecedence
extension Queue {
    
    static func <- (lhs: inout Queue<T>, rhs:T) {
        lhs.enqueue(rhs)
    }
}

prefix operator --
extension Queue {
    
    @discardableResult
    static prefix func -- (lhs: inout Queue<T>) -> T? {
        lhs.dequeue()
    }
}
