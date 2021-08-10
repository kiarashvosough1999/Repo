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
}
