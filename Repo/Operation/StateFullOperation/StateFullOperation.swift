//
//  SafeOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

/**
 
 A state managable operation which it inherited from `SafeOperation`
 
 * This is more or less how state changes
 
                                 +---------------+
                                 |               |
            +--------------------|     Ready     |---------------------------+
            |                    |               |                           |
            |                    +----------+----+                           |
            |                               ↑                                |
            |                               |                                |
            |                               |                                |
            ↓                               |                                ↓
     +---------------+                      |                         +---------------+
     |               |-----------------------------------------------→+               |
     |   Executing   |-------------------+  |                         |   Canceled    |
     |               |                   |  |                         |               |
     +-------+-------+                   |  |                         +------+--------+
             |                           |  |                                ↑
             |                           |  |                                |
             |                           |  |                                |
             ↓                           ↓  |                                |
     +-------+---------+            +----+--+---------+                      |
     |                 |            |                 |                      |
     |    Finished     +←-----------|    Suspended    |----------------------+
     |                 |            |                 |
     +-----------------+            +-----------------+
 
 After the state change, the `WorkItem` related to the new state will begin to perform.
 
 Each `WorkItem` can be overriden by the subclasses to implement their custom action
 
 
 
 */

public class StateFullOperation: SafeOperation, ControlableOperation, OperationContextStateObject {
    
    /// initialize this propery after super.init() call otherwise it results in crash
    internal var operationState:OperationStateProtocol {
        didSet {
            isExecuting = operationState.isExecuting
            isFinished = operationState.isFinished
            isCancelled = operationState.isCanceled
        }
    }
    
    // MARK: -  Execution Blocks For Each State
    
    typealias WorkerItemBlock = () -> WorkerItem
    
    /// Could be provided by any subclass to execute some code before the operation state changes to `finished`.
    internal private(set) var onFinished: WorkerItemBlock?
    
    /// Could be provided by any subclass to execute some code before the operation state changes to `executing`.
    /// instead of overriding main() function, override this property and provide a block of what you want when the operation start.
    internal private(set) var onCanceled: WorkerItemBlock?
    
    /// Could be provided by any subclass to execute some code before the operation state changes to `canceled`.
    internal private(set) var onExecuting: WorkerItemBlock?
    
    /// Could be provided by any subclass to execute some code before the operation state changes to `suspended`.
    /// The operation itself does not support suspending.
    /// This extra state help some task to be paused and be resumed when the user asked
    /// The operation will remain on queue but not executing
    /// For URLSessionDataTasks:
    /// - Provide block only on download and upload tasks
    /// - Providing block on other tasks and using it may result in crash, leak and unexpected usage of network data.
    internal private(set) var onSuspended: WorkerItemBlock?
    
    //MARK: - init
    
    init(operationQueue: OperationQueue?,
         configuration: OperationConfiguration,
         operationState:OperationStateProtocol = OperationReadyState(queueState: .init(enqueued: false))) {
        self.operationState = operationState
        super.init(operationQueue: operationQueue, configuration: configuration)
    }
    
    
    //MARK: - Operation Control Flags
    
    /// Change the state of opertaion
    /// - Parameter state: Next State
    /// - Returns: Return new state of the context
    @discardableResult
    internal func changeState(new state: OperationStateProtocol) -> OperationStateProtocol {
        self.operationState = state
        return self.operationState
    }
    
    public override func shouldStartRunnable() throws {
        if isCancelled {
            do {
                guard let onCanceled = onCanceled?() else {
                    throw
                    OperationError
                    .workItemFoundNil(tyep: .onCanceled, description:
                                        """
                                        onCanceled was found nil while attempting to unwrap it
                                        on start method of operation with identifier:\(self.identifier)
                                        """)
                }
                try operationState.cancelOperation(and: onCanceled)
            }catch {
                print(error)
            }
            return
        }
        do {
            try operationState.start()
        } catch  {
            print(error)
        }
    }
    
    public override func runnable() throws {
        guard let onExecuting = onExecuting?() else {
            fatalError("onExecuting was found nil")
        }
        onExecuting.perform(on: operationQueue?.underlyingQueue)
    }
    
    @discardableResult
    public func completeOperation() throws -> Self {
        guard let onFinished = onFinished?() else {
            fatalError("onFinished was found nil")
        }
        try operationState.completeOperation(and: onFinished)
        return self
    }
    
    @discardableResult
    public func cancelOperation() throws -> Self {
        guard let onCanceled = onCanceled?() else {
            fatalError("onCanceled was found nil")
        }
        try operationState.cancelOperation(and: onCanceled)
        return self
    }
    
    @discardableResult
    public func suspend(after deadline: TimeInterval) throws -> Self {
        guard let onSuspended = onSuspended?() else {
            fatalError("onSuspended was found nil")
        }
        try operationState.suspend(after: deadline, execute: onSuspended)
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
    
    public func setOperationCompletedSignal(_ sig: OperationCompletedSignal?) -> Self {
        completionBlock = sig
        return self
    }
}
