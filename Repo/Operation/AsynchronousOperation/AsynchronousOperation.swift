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
    
    /// Custome configuration which user can modify to change the operation behavior
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
    
    // MARK: -  execution Blocks For Each State
    
    /// Could be provided by any subclass to execute some code before the operation state changes to `finished`.
    internal private(set) var onFinish: OperationCompletedSignal?
    
    /// Could be provided by any subclass to execute some code before the operation state changes to `executing`.
    /// instead of overriding main() function, override this property and provide a block of what you want when the operation start.
    internal private(set) var onExecuting: OperationCompletedSignal?
    
    /// Could be provided by any subclass to execute some code before the operation state changes to `canceled`.
    internal private(set) var onCancel: OperationCompletedSignal?
    
    /// Could be provided by any subclass to execute some code before the operation state changes to `suspended`.
    /// The operation itself does not support suspending.
    /// This extra state help some task to be paused and be resumed when the user asked
    /// The operation will remain on queue but not executing
    /// For URLSessionDataTasks:
    /// - Provide block only on download and upload tasks
    /// - Providing block on other tasks and using it may result in crash, leak and unexpected usage of network data.
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
