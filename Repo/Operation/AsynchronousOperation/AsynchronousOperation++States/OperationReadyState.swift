//
//  OperationReadyState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

internal class OperationReadyState<Context>: OperationStateProtocol where Context: StateFullOperation &
                                                                            CommandExecutable &
                                                                            ConfigurableOperation {
    
    internal weak var context: Context?
    internal var isFinished: Bool { false }
    internal var isExecuting: Bool { false }
    internal var isCanceled: Bool = false
    internal var isSuspended: Bool = false
    internal var state: OperationState { .ready }
    internal var queueState:QueueState
    
    required internal init(context: Context? = nil, queueState:QueueState) {
        self.context = context
        self.queueState = queueState
    }
    
    
    func cancelOperation(and execute: WorkerItem?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        context.commandHistory.set(
            CancelCommand(on: context, [
                .init(dispathOption: .asyncWithInheritedQueue,
                      block: { [weak context, queueState]  in
                    guard let context = context else { fatalError() }
                    context.changeState(new: OperationCancelState(context: context, queueState: queueState))
                })
            ])
        )
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
        self.queueState.enqueued = true
        context.commandHistory.set(
            StartCommand(on: context, [
                .init(dispathOption: .asyncWithInheritedQueue, block: { [weak context, queueState]  in
                    guard let context = context else { fatalError() }
                    context.changeState(new: OperationExecutingState(context: context, queueState: queueState))
                    context.main()
                })
            ])
        )
    }
    
    func completeOperation(and execute: WorkerItem?) throws {
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
    
    func suspend(after deadline: TimeInterval, execute: WorkerItem?) throws {
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
    
    internal func await(after deadline:TimeInterval = 0) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }

        if queueState.enqueued {
            context.commandHistory.set(
                AwaitCommand(on: context, [
                    .init(dispathOption: .asyncAfterWithInheritedQueue(deadline: deadline),
                          block: { [weak context]  in
                        guard let context = context else { fatalError() }
                        context.start()
                    })
                ])
            )
            return
        }
        
        
        self.queueState.enqueuedAfter = deadline
        context.commandHistory.set(
            AwaitCommand(on: context, [
                .init(dispathOption: .asyncAfterWithInheritedQueue(deadline: deadline),
                      block: { [weak context]  in
                    guard let context = context else { fatalError() }
                    context.operationQueue?.addOperation(context)
                })
            ])
        )
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
