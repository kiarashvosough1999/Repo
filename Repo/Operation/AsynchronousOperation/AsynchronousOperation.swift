//
//  AsynchronousOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public class AsynchronousOperation: Operation,
                                    AsynchronousOperationProtocol,
                                    OperationContextStateObject {
    
    lazy internal var operationState: OperationStateProtocol = {
        return OperationReadyState(context: self, queueState: .init(enqueued: false))
    }()
    
    /// Custome configuration which user can modify to change th operation behavior
    internal private(set) var operationConfiguration: OperationConfig
    
    /// a `mutex lock` to `synchronize` some properties between threads
    internal let lock: NSLock
    
    /// the `Operation Queue` which this operation work with
    internal private(set) weak var operationQueue:OperationQueue?
    
    /// `Thread Safe Readable` Variables Indicating Operation Status
    
    lazy public internal(set) var _executing: Bool = false
    
    lazy public internal(set) var _finished: Bool = false
    
    lazy public internal(set) var _canceled: Bool = false
    
    lazy public internal(set) var _suspended: Bool = false
    
    internal private(set) var onFinish: OperationCompletedSignal?
    
    internal private(set) var onExecuting: OperationCompletedSignal?
    
    internal private(set) var onCancel: OperationCompletedSignal?
    
    internal private(set) var onSuspend: OperationCompletedSignal?
    
    //MARK: - Init
    
    internal init(operationQueue: OperationQueue?,
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
        guard operationState.canModifyOperationConfig else {
            throw OperationError.cantChangeOperationConfigOnCurrentState(String(describing: operationState.self))
        }
        config(&self.operationConfiguration)
        self.queuePriority = operationConfiguration [keyPath:\.queuePriority]
        self.qualityOfService = operationConfiguration [keyPath:\.qualityOfService]
        self.name = operationConfiguration[keyPath:\.identifierGenerator]().rawValue
        return self
    }
    
    public func setOperationCompletedSignal(_ sig: OperationCompletedSignal?) -> Self {
        completionBlock = sig
        return self
    }
    
    
}
