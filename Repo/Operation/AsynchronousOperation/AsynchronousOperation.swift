//
//  AsynchronousOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public protocol ConfigurableOperation {
    var operationConfiguration: OperationConfig { get }
    func changeOperationConfig(_ config: (inout OperationConfig) -> ()) throws -> Self
}

public class AsynchronousOperation: StateFullOperation,
                                    AsynchronousOperationProtocol,
                                    ConfigurableOperation,
                                    CommandExecutable {
    
    internal private(set) var commandHistory:CommandHistory
    
    /// Custome configuration which user can modify to change the operation behavior
    public private(set) var operationConfiguration: OperationConfig
    
    //MARK: - Init
    
    internal init(operationQueue: OperationQueue,
                  operationConfiguration: OperationConfig) {
        self.operationConfiguration = operationConfiguration
        self.commandHistory = CommandHistory(commandOperationQueue: OperationQueue(),
                                             underlyingQueue: operationQueue.underlyingQueue!)
        super.init(operationQueue: operationQueue)
        self.operationState = OperationReadyState<AsynchronousOperation>(context: self,
                                                                         queueState: .init(enqueued: false))
        self.setOperationConfigurationChanges()
    }
    
    /// User can call this function on result of request `before` the `await` function been called to modify configuration
    /// - Parameter config: Configuration associated with `this` `Operation`
    /// - Returns: Self
    public func changeOperationConfig(_ config: (inout OperationConfig) -> ()) throws -> Self {
        guard operationState.canModifyOperationConfig else {
            throw OperationError.cantChangeOperationConfigOnCurrentState(String(describing: operationState.self))
        }
        config(&self.operationConfiguration)
        setOperationConfigurationChanges()
        return self
    }
    
    internal func setOperationConfigurationChanges() {
        self.queuePriority = operationConfiguration [keyPath:\.queuePriority]
        self.qualityOfService = operationConfiguration [keyPath:\.qualityOfService]
        self.name = operationConfiguration[keyPath:\.identifierGenerator]().rawValue
    }

    
//    /// Complete operation by changing its `state`
//    /// - Throws: Error of kind `OperationControllerError`
//    /// - Returns: Self
//    @discardableResult
//    public override func completeOperation() throws -> Self {
//        try operationState.completeOperation(and: nil)
//        return self
//    }
//    
//    /// Cancel operation by changing its `state`
//    /// - Throws: Error of kind `OperationControllerError`
//    /// - Returns: Self
//    @discardableResult
//    public override func cancelOperation() throws -> Self {
//        try operationState.cancelOperation(and: nil)
//        return self
//    }
//    
//    /// Start operation by changing its `state`
//    /// - Throws: Error of kind `OperationControllerError`
//    /// - Returns: Self
//    @discardableResult
//    public override func await(after deadline: TimeInterval = 0) throws -> Self {
//        try operationState.await(after: deadline)
//        return self
//    }
//    
//    @discardableResult
//    public override func suspend(after deadline: TimeInterval) throws -> Self {
//        try self.operationState.suspend(after: deadline, execute: nil)
//        return self
//    }
//    
//    public override func start() {
//        do {
//            try operationState.start()
//        } catch  {
//            print(error)
//        }
//    }
}
