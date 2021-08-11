//
//  NSLocking++Extensions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/20/1400 AP.
//

import Foundation

extension NSLocking {
    
    internal func synchronize<T>(block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
