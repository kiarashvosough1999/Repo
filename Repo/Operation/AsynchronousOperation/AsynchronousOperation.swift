//
//  AsynchronousOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public class AsynchronousOperation: Operation, AsynchronousOperationProtocol, OperationContextStateObject {
    
    lazy public var state: OperationState = OperationReadyState(context: self)
    
    /// `Unique` identifier for this operation
    public var identifier: OperationIdentifier {
        guard let name = name,
              let id = OperationIdentifier(rawValue: name) else {
            fatalError("operation has no identifier")
        }
        return id
    }
    
    public var operationCompletedSignal: OperationCompletedSignal? {
        get { completionBlock }
        set { completionBlock = newValue }
    }
    
    /// Custome configuration which user can modify to change th operation behavior
    private(set) var operationConfiguration: OperationConfig
    
    /// Overridabel property indicating whether the operation is `async` or not
    public override var isAsynchronous: Bool { return true }
    
    /// a `mutex lock` to `synchronize` some properties between threads
    private let lock: NSLock

    /// the `Operation Queue` which this operation work with
    private(set) weak var operationQueue:OperationQueue?
    
    // MARK: - Thread Safe Variables Indicating Operation Status
    
    lazy public var _executing: Bool = false /// `Thread Safe` getter

    public override private(set) var isExecuting: Bool {
        get {
            return lock.synchronize { _executing }
        }
        set {
            willChangeValue(forKey: "isExecuting")
            lock.synchronize { _executing = newValue }
            didChangeValue(forKey: "isExecuting")
        }
    }

    lazy public var _finished: Bool = false /// `Thread Safe` getter
    
    public override private(set) var isFinished: Bool {
        get {
            return lock.synchronize { _finished }
        }
        set {
            willChangeValue(forKey: "isFinished")
            lock.synchronize { _finished = newValue }
            didChangeValue(forKey: "isFinished")
        }
    }
    
    //MARK: - Init
    
    init(operationQueue: OperationQueue? = nil,
         operationConfiguration: OperationConfig) {
        self.lock = NSLock()
        self.operationQueue = operationQueue
        self.operationConfiguration = operationConfiguration
        super.init()
        self.queuePriority = operationConfiguration [keyPath:\.queuePriority]
        self.qualityOfService = operationConfiguration [keyPath:\.qualityOfService]
        self.name = operationConfiguration[keyPath:\.identifierGenerator]().rawValue
    }
    
    /// User can call this function on result of request `before` the `await` function been called to modify configuration
    /// - Parameter config: Configuration associated with `this` `Operation`
    /// - Returns: Self
    public func changeOperationConfig(_ config: (inout OperationConfig) -> ()) throws -> Self {
        guard state.canModifyOperationConfig else {
            throw OperationError.cantChangeOperationConfigOnCurrentState(String(describing: state.self))
        }
        config(&self.operationConfiguration)
        self.queuePriority = operationConfiguration [keyPath:\.queuePriority]
        self.qualityOfService = operationConfiguration [keyPath:\.qualityOfService]
        self.name = operationConfiguration[keyPath:\.identifierGenerator]().rawValue
        return self
    }
    
    //MARK: - Operation Control
    
    /// Change the state of opertaion
    /// - Parameter state: Next State
    final func changeState(new state: OperationState) {
        self.state = state
        self.state.context = self
        _executing = state.isExecuting
        isExecuting = state.isExecuting
        _finished = state.isFinished
        isFinished = state.isFinished
    }
    
    /// Complete operation by changing its `state`
    /// - Throws: Error of kind `OperationControllerError`
    /// - Returns: Self
    @discardableResult
    public func completeOperation() throws -> Self {
        try state.completeOperation()
        return self
    }
    
    /// Cancel operation by changing its `state`
    /// - Throws: Error of kind `OperationControllerError`
    /// - Returns: Self
    @discardableResult
    public func cancelOperation() throws -> Self {
        try state.cancelOperation()
        return self
    }
    
    /// Start operation by changing its `state`
    /// - Throws: Error of kind `OperationControllerError`
    /// - Returns: Self
    @discardableResult
    public func await(after: TimeInterval = 0) throws -> Self {
        try state.await(after: after)
        return self
    }

    public override func start() {
        do {
            try state.start()
        } catch  {
            print(error)
        }
    }
    
    public override func cancel() {
        changeState(new: OperationCancelState())
        super.cancel()
    }
    
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


extension NSLocking {

    internal func synchronize<T>(block: () throws -> T) rethrows -> T {
        lock()
        defer { unlock() }
        return try block()
    }
}
