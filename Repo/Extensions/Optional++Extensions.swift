//
//  Optional++Extensions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

extension Optional {
    
    enum OptionalError:Error {
        case Nil
        case callBackNil
    }
    
    /// Returns a Bool value  for `nil` value
    var isNil:Bool {
        return self == nil
    }
    
    mutating func toggleNil() {
        guard !self.isNil else {
            return
        }
        self = nil
    }
    
    /// Returns the wrapped value that satisfy predicate otherwise return`nil`
    func matching(_ predicate: (Wrapped) -> Bool) -> Wrapped? {
        guard let value = self else {
            return nil
        }
        
        guard predicate(value) else {
            return nil
        }
        
        return value
    }
    
    /// Returns the wrapped value or crashes with `fatalError(message)`
    func expect(_ message: String) -> Wrapped {
        guard let value = self else { fatalError(message) }
        return value
    }
    
    /// Execute some closure if optionsl is not`nil`
    func on(some: () throws -> Void) rethrows {
        if self != nil { try some() }
    }
    
    func on(some: (Wrapped) throws -> Void) rethrows {
        if self != nil { try some(self!) }
    }
    
    /// Execute `some` closure if optionsl is not`nil` otherwise executes `none`
    func on(some: (Wrapped) throws -> Void, none: () throws -> Void) rethrows {
        if let self = self { try some(self) }
        else { try none() }
    }
    
    /// Execute `some` closure if optionsl is not`nil` otherwise executes `none`
    func on(_ some: (Wrapped) throws -> Void, _ none: () throws -> Void) rethrows {
        if let self = self { try some(self) }
        else { try none() }
    }
    
    /// Executes the closure `none` if and only if the optional has no value
    func on(none: () throws -> Void) rethrows {
        if self == nil { try none() }
    }
    
    /// Return the value of the Optional or the `default` parameter
    /// - param: The value to return if the optional is empty
    func or(_ default: Wrapped) -> Wrapped {
        return self ?? `default`
    }
    
    /// Returns the unwrapped value of the optional *or*
    /// the result of an expression `else`
    /// I.e. optional.or(else: print("Arrr"))
    func or(else: @autoclosure () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    /// Returns the unwrapped value of the optional *or*
    /// the result of calling the closure `else`
    /// I.e. optional.or(else: {
    /// ... do a lot of stuff
    /// })
    func or(else: () -> Wrapped) -> Wrapped {
        return self ?? `else`()
    }
    
    /// Returns the unwrapped contents of the optional if it is not empty
    /// If it is empty, throws exception `throw`
    func or(throw exception: Error) throws -> Wrapped {
        guard let unwrapped = self else { throw exception }
        return unwrapped
    }
}

extension Optional where Wrapped == Error {
    /// Only perform `else` if the optional has a non-empty error value
    func or(_ else: (Error) -> Void) {
        guard let error = self else { return }
        `else`(error)
    }
}

public extension Optional where Wrapped: Collection {
    var isEmpty: Bool {
        guard case let .some(val) = self else {
            return true
        }
        
        return val.isEmpty
    }
}
