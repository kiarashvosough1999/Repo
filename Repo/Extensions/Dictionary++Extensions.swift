//
//  Dictionary++Extensions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/6/1400 AP.
//

import Foundation

extension Dictionary {
    
    static func +=(lhs: inout [Self.Key: Self.Value], rhs: [Self.Key: Self.Value]) {
        rhs.forEach { lhs[$0] = $1 }
    }
    
    mutating func remove(_ where: (Dictionary<Key, Value>.Element) throws -> Bool) rethrows {
        try self
            .filter(`where`)
            .forEach {
                self.removeValue(forKey: $0.key)
            }
    }
    
    mutating func remove(_ where: (Dictionary<Key, Value>.Element) throws -> Bool,
                         execute onEach: (Dictionary<Key, Value>.Element) throws -> Void) rethrows {
        try self
            .filter(`where`)
            .forEach {
                try onEach($0)
                self.removeValue(forKey: $0.key)
            }
    }
    
}

infix operator <- : AssignmentPrecedence
extension Dictionary where Key == OperationIdentifier {
    
    static func <- <T>(lhs: inout [Self.Key: Self.Value], rhs: T) -> T where T: IdentifiableOperation{
        lhs.updateValue(rhs as! Self.Value, forKey: rhs.identifier)
        return rhs
    }
    
    static func <- (lhs: inout [Self.Key: Self.Value], rhs: Self.Value) -> Self.Value where Self.Value: IdentifiableOperation{
        lhs.updateValue(rhs , forKey: rhs.identifier)
        return rhs
    }
}



