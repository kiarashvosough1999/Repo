//
//  Array++Extensions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation


infix operator <- : AssignmentPrecedence
extension Array {
    
    static func <- (lhs: inout Self, rhs:Element) {
        lhs.append(rhs)
    }
    
    static func <- <T>(lhs: inout Self, rhs:T) -> T {
        lhs.append(rhs as! Element)
        return rhs
    }
}
