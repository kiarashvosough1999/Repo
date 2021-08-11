//
//  Operation++Extensions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

extension Operation {
    
    enum OperationError: Error {
        case taskNil(String)
        case cantCastOperation
        case cantChangeOperationConfigOnCurrentState(String)
    }
    
    func dependecies<T>() throws -> [T] {
        guard let dep = self.dependencies as? [T] else {
            throw OperationError.cantCastOperation
        }
        return dep
    }
}
