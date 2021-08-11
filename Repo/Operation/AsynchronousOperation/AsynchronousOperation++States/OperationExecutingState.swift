//
//  OperationExecutingState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

internal class OperationExecutingState: OperationStateProtocol {
    
    internal weak var context: AsynchronousOperation?
    internal var isFinished: Bool { false }
    internal var isExecuting: Bool { true }
    internal var isCanceled: Bool = false
    internal var isSuspended: Bool = false
    internal var state: OperationState { .executing }
    internal var queueState: QueueState
    
    internal init(context: AsynchronousOperation? = nil, queueState: QueueState) {
        self.context = context
        self.queueState = queueState
    }
    
    
    /// This Method is just handeling await request when an operation should be suspended after an amount of time
    /// and user request to await before that time reachs,
    /// it will make async block to call await after the state changes to Suspended
    /// - Parameter deadline: amount of time to tolerate until the operation will be added
    /// - Throws:
    ///  - OperationControllerError.dealocatedOperation on context nil
    ///  - OperationControllerError.operationQueueIsNil on underlyingQueue nil
    func await(after deadline: TimeInterval) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        guard let operationQueue = context.operationQueue?.underlyingQueue else {
            throw OperationControllerError.operationQueueIsNil(
                """
                    underlyingQueue associated with operationQueue on Operation
                    with identifier: \(context.identifier)
                    was found nil,can not suspend this operation
                """)
        }
        if queueState.suspendedAfter > 0.0 {
            operationQueue.async(execute: {
                do {
                    try context.await(after: deadline)
                }catch {
                    print(error)
                }
            })
        }
        throw OperationControllerError.misUseError(
            """
            await method should only be called once or after suspension.
            """
        )
    }
    
    /// Complete operation by calling
    /// 1. `onFinish` block
    /// 2. Changing state to `OperationFinishState`
    /// - Parameter execute: onFinish block which was provoded by overriding it on subclasses
    /// - Throws: OperationControllerError.dealocatedOperation or
    internal func completeOperation(and execute: OperationCompletedSignal?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        guard let execute = execute else {
            throw OperationControllerError.nilBlock(
                """
                complete block could not be executed on\(String(describing: self)) while it is nil
                cannot change state
                """
            )
        }
        execute()
        context.changeState(new: OperationFinishState(context: context, enqueued: queueState.enqueued))
    }
    
    func cancelOperation(and execute: OperationCompletedSignal?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        guard let execute = execute else {
            throw OperationControllerError.nilBlock(
                """
                cancel block could not be executed on\(String(describing: self)) while it is nil
                cannot change state
                """
            )
        }
        execute()
        context.changeState(new: OperationCancelState(context: context, queueState: queueState))
        context.cancel()
    }
    
    func suspend(after deadline: TimeInterval, execute: OperationCompletedSignal?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)),
                cannot change state
                """
            )
        }
        guard let execute = execute else {
            throw OperationControllerError.nilBlock(
                """
                suspend block could not be executed
                on\(String(describing: self)) while it is nil
                cannot change state
                """
            )
        }
        guard let operationQueue = context.operationQueue?.underlyingQueue else {
            throw OperationControllerError.operationQueueIsNil(
                """
                    underlyingQueue associated with operationQueue on Operation
                    with identifier: \(context.identifier)
                    was found nil,can not suspend this operation
                """)
        }
        self.queueState.suspendedAfter = deadline
        
        operationQueue.asyncAfter(deadline: .now() + deadline) { [weak self] in
            guard let self = self else {
                fatalError(
                    "State \(String(describing: self)) was dealocated"
                )
            }
            execute()
            self
                .context?
                .changeState(new: OperationSuspendState(context: context,
                                                        queueState: self.queueState))
        }
    }
    
}
