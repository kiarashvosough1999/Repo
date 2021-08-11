//
//  OperationReadyState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

internal class OperationReadyState: OperationStateProtocol {
    
    internal weak var context: AsynchronousOperation?
    internal var isFinished: Bool { false }
    internal var isExecuting: Bool { false }
    internal var isCanceled: Bool = false
    internal var isSuspended: Bool = false
    internal var state: OperationState { .ready }
    internal var queueState:QueueState
    
    internal init(context: AsynchronousOperation? = nil, queueState:QueueState) {
        self.context = context
        self.queueState = queueState
    }
    
    internal func cancelOperation(and execute: OperationCompletedSignal?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        context.changeState(new: OperationCancelState(context: context, queueState: queueState))
    }
    
    /// First the `await` method should be called  then
    /// This method will be called on overided method `start` (when OperationQueue attemp to call it)
    /// on operation subclass in order to start task and change its state
    /// `enqueued.enqueued` is `true` on this state
    /// - Throws: Throws OperationControllerError.dealocatedOperation if the context is nil
    internal func start() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        // handle complete and cancel event when deadline is more than 0.0 and operation is waiting to be enqueued
        context.changeState(new: OperationExecutingState(context: context, queueState: queueState))
        context.main()
    }
    
    internal func completeOperation(and execute: OperationCompletedSignal?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        throw OperationControllerError.operationIsNotExecutingToFinish(
            """
            Operation with identifier: \(context.identifier) is not executing to complete.
            only executing operation can be completed with `completeOperation` method.
            try to cancel if you want to prevent it from execution.
            """
        )
    }
    
    func suspend(after: TimeInterval, execute: OperationCompletedSignal?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        throw OperationControllerError.operationIsNotExecutingToFinish(
            """
            Operation with identifier: \(context.identifier) is not executing to suspend.
            only executing operation can be suspended with `suspendOperation` method.
            try to cancel if you want to prevent it from execution.
            """
        )
    }
    
    /// Each time calling `await` on an operation will result in async adding  the operation to `OperationQueue` within its `underlyingQueue`
    /// This method should not be called when operation is already on a queue
    /// The state of the operation won't be afected until `start` triggering
    /// `start` method will be called ofter the deadline
    /// - Parameter after: amount of time to tolerate until the operation will be added
    /// - Throws: Throws OperationControllerError.dealocatedOperation if the context is nil
    internal func await(after:TimeInterval = 0) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        guard !queueState.enqueued  else {
            throw OperationControllerError.misUseError(
                "operation with identifier \(context.identifier) is already enqueued on a queue"
            )
        }
        
        if queueState.enqueued {
            context
                .changeState(new: OperationExecutingState(context: context,
                                                          queueState: queueState))
            return
        }
        
        try context.operationQueue.on { operationQueue in
            try operationQueue.underlyingQueue.on { queue in
                self.queueState.enqueuedAfter = after
                queue.asyncAfter(deadline: .now() + after) { [weak self] in
                    guard let self = self else {
                        fatalError(
                            "State \(String(describing: self)) was dealocated"
                        )
                    }
                    operationQueue.addOperation(context)
                    self.queueState.enqueued = true
                }
            } none: {
                throw OperationControllerError.operationQueueIsNil(
                    """
                        underlyingQueue associated with operationQueue on Operation
                        with identifier: \(context.identifier)
                        was found nil,can not add this operation to execute
                    """)
            }
            //            context.changeState(new: OperationExecutingState())
        } none: {
            throw OperationControllerError.operationQueueIsNil(
                """
                operationQueue on operation with identifier: \(context.identifier)
                    was found nil,can not add this operation to execute
                """)
        }
        // block the current thread until all operation finish
        // new operation cant be added to queue during this block time
        context
            .operationConfiguration
            .waitUntilAllOperationsAreFinished
            .accept {
                context.operationQueue?.waitUntilAllOperationsAreFinished()
            }
    }
}
