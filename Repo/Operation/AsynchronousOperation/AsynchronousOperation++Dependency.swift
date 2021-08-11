//
//  AsynchronousOperation++Dependency.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/20/1400 AP.
//

import Foundation

extension AsynchronousOperation {
    
    //MARK: - Dependencies
    
    /// Remove dependency from this operation,
    /// - Parameter identifier: Operation which `this` operation depends on
    /// - Throws: `OperationControllerError.operationNotFound` if no operation found with the given identifier
    /// - Returns: `Self`
    @discardableResult
    public func removeDependency(with identifier: OperationIdentifier) throws -> Self {
        guard let op = self.dependencies.first(where: { OperationIdentifier(rawValue: $0.name!) == identifier }) else {
            throw OperationControllerError.operationNotFound(
                """
                operation with identifier\(identifier) not found to remove
                """
            )
        }
        self.removeDependency(op)
        return self
    }
    
    /// Remove dependency from this operation,
    /// - Parameter name: Operation which `this` operation depends on
    /// - Throws: `OperationControllerError.operationNotFound` if no operation found with the given name
    /// - Returns: `Self`
    @discardableResult
    public func removeDependency(with name: String) throws -> Self {
        guard let op = self.dependencies.filter({ $0.name == name }).first else {
            throw OperationControllerError.operationNotFound (
                """
                operation with identifier\(identifier) not found to remove
                """
            )
        }
        self.removeDependency(op)
        return self
    }
    
    /// Remove dependency from this operation and cancel target operation
    /// - Parameter name: Operation which `this` operation depends on
    /// - Throws: `OperationControllerError.operationNotFound` if no operation found with the given name
    /// - Returns: `Self`
    @discardableResult
    public func removeDependencyAndCancelTraget(with name: String) throws -> Self {
        guard let op:Operation = dependencies.filter({ $0.name == name }).first else {
            throw OperationControllerError.operationNotFound(
                """
                operation with identifier\(identifier) not found to remove
                """
            )
        }
        self.removeDependency(op)
        op.cancel()
        return self
    }
    
    /// Remove dependency from this operation and cancel source operation
    /// - Parameter name: Operation which `this` operation depends on
    /// - Throws: `OperationControllerError.operationNotFound` if no operation found with the given name
    /// - Returns: `Self`
    @discardableResult
    public func removeDependencyAndCancel(with name: String) throws -> Self {
        guard let op:Operation = dependencies.filter({ $0.name == name }).first else {
            throw OperationControllerError.operationNotFound(
                """
                operation with identifier\(identifier) not found to remove
                """
            )
        }
        self.removeDependency(op)
        try self.cancelOperation()
        return self
    }
    
    /// make this operation depend on another
    /// - Parameter op: Operation which this Operation will be depend on
    /// - Throws: OperationControllerError.canNotAddDependency if Target or Source Operation was canceled or finished
    /// - Returns: `Self`
    @discardableResult
    public func dependsOn(_ op: Operation) throws -> Self {
        if op.isFinished || op.isCancelled {
            throw OperationControllerError.canNotAddDependency(
                """
             destenation operation with identifier\(identifier) can not have dependency, it is canceled or finished
            """
            )
        }
        if isFinished || isCancelled {
            throw OperationControllerError.canNotAddDependency(
                """
                operation with identifier\(identifier) can not have dependency, it is canceled or finished
                """
            )
        }
        self.addDependency(op)
        return self
    }
    
    /// make this operation depend on another with given identifier
    /// - Parameter identifier: Target Operation which this operation will be depend on
    /// - Throws: OperationControllerError.canNotAddDependency if Target or Source Operation was canceled or finished or `OperationControllerError.operationNotFound` if no operation found with the given name
    /// - Returns: `Self`
    @discardableResult
    public func dependsOnOperation(with identifier: OperationIdentifier) throws -> Self {
        guard let op = self.dependencies.first(where: { OperationIdentifier(rawValue: $0.name!) == identifier }) else {
            throw OperationControllerError.operationNotFound(
                """
                operation with identifier\(identifier) not found to remove
                """
            )
        }
        if op.isFinished || op.isCancelled {
            throw OperationControllerError.canNotAddDependency(
                """
             destenation operation with identifier\(identifier) can not have dependency, it is canceled or finished
            """
            )
        }
        if isFinished || isCancelled {
            throw OperationControllerError.canNotAddDependency(
                """
             this operation with identifier\(self.identifier) can not have dependency, it is canceled or finished
            """
            )
        }
        self.addDependency(op)
        return self
    }
}
