//
//  AsynchronousOperation++State.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/20/1400 AP.
//

import Foundation

extension AsynchronousOperation {
    
    //MARK: - Operation Control Flags
    
    public override internal(set) var isExecuting: Bool {
        get {
            return lock.synchronize { _executing }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lock.synchronize { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }
    public override internal(set) var isFinished: Bool {
        get {
            return lock.synchronize { _finished }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lock.synchronize { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    public override internal(set) var isCancelled: Bool {
        get {
            return lock.synchronize { _canceled }
        }
        set {
            willChangeValue(forKey: "isCancelled")
            lock.synchronize { _canceled = newValue }
            didChangeValue(forKey: "isCancelled")
        }
    }
    
    /// Change the state of opertaion
    /// - Parameter state: Next State
    /// - Returns: Return new state of the context
    @discardableResult
    internal func changeState(new state: OperationStateProtocol) -> OperationStateProtocol {
        self.operationState = state
        isExecuting = state.isExecuting
        isFinished = state.isFinished
        isCancelled = state.isCanceled
        return self.operationState
    }
    
    /// Complete operation by changing its `state`
    /// - Throws: Error of kind `OperationControllerError`
    /// - Returns: Self
    @discardableResult
    public func completeOperation() throws -> Self {
        try operationState.completeOperation(and: onFinish)
        return self
    }
    
    /// Cancel operation by changing its `state`
    /// - Throws: Error of kind `OperationControllerError`
    /// - Returns: Self
    @discardableResult
    public func cancelOperation() throws -> Self {
        try operationState.cancelOperation(and: onCancel)
        return self
    }
    
    /// Start operation by changing its `state`
    /// - Throws: Error of kind `OperationControllerError`
    /// - Returns: Self
    @discardableResult
    public func await(after deadline: TimeInterval = 0) throws -> Self {
        try operationState.await(after: deadline)
        return self
    }
    
    @discardableResult
    public func suspend(after deadline: TimeInterval) throws -> Self {
        try self.operationState.suspend(after: deadline, execute: self.onSuspend)
        return self
    }
    
    public override func start() {
        do {
            try operationState.start()
        } catch  {
            print(error)
        }
    }
    
    public override func main() {
        onExecuting?()
    }
}
