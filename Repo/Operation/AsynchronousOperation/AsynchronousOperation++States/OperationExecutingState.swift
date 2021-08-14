//
//  OperationExecutingState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

internal class OperationExecutingState: OperationStateProtocol  {
    
    
    internal weak var context: Context?
    internal var isFinished: Bool { false }
    internal var isExecuting: Bool { true }
    internal var isCanceled: Bool = false
    internal var isSuspended: Bool = false
    internal var state: OperationState { .executing }
    internal var queueState: QueueState
    
    required internal init(context: Context? = nil, queueState: QueueState) {
        self.context = context
        self.queueState = queueState
        self.queueState.enqueued = true
    }
    
    func start() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        throw OperationControllerError.operationIsNotExecutingToFinish(
            """
            Operation with identifier: \(context.identifier) is already Executing
            Could not be started
            """
        )
    }
    
    /// This Method is just handeling await request when an operation should be suspended after an amount of time
    /// and user request to await before that time reachs,
    /// it will make async recursive block to call await when the state changes to Suspended
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
        /// all command are sync now tthis is useless
//        if queueState.suspendedAfter > 0.0 {
//
//            context.commandHistory.set(
//                AwaitCommand(on: context,[
//                    .init(dispathOption: .asyncAfterWithInheritedQueue(deadline: deadline),
//                          block: { [weak context] in
//                            guard let context = context else { fatalError() }
//                            do {
//                                try context.await(after: deadline)
//                            }
//                            catch {
//                                print(error)
//                            }
//                          })
//                ])
//            )
//            return
//        }
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
    func completeOperation(and execute: WorkerItem?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
            context was dealocated on\(String(describing: self)), cannot change state
            """
            )
        }
        guard let onFinished = execute else {
            throw OperationControllerError.nilBlock(
                """
                cancel block could not be executed on\(String(describing: self)) while it is nil
                cannot change state
                """
            )
        }
        context.commandHistory.setCommand(
            CompeleteCommand(dispathOption: .unsafeSync) { [weak context,queueState] in
                guard let context = context else { fatalError() }
                context.changeState(new: OperationFinishState(context: context, queueState: queueState))
                onFinished.perform(on: nil)
                
            }
        )
    }
    func cancelOperation(and execute: WorkerItem?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        guard let onCanceled = execute else {
            throw OperationControllerError.nilBlock(
                """
                cancel block could not be executed on\(String(describing: self)) while it is nil
                cannot change state
                """
            )
        }
        
        context.commandHistory.setCommand(
            CancelCommand(dispathOption: .unsafeSync) { [weak context, queueState] in
                guard let context = context else { fatalError() }
                context.changeState(new: OperationCancelState(context: context, queueState: queueState))
                onCanceled.perform(on: nil)
            }
        )
    }
    
    
    func suspend(after deadline: TimeInterval, execute: WorkerItem?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)),
                cannot change state
                """
            )
        }
        guard let onSuspended = execute else {
            throw OperationControllerError.nilBlock(
                """
                suspend block could not be executed
                on\(String(describing: self)) while it is nil
                cannot change state
                """
            )
        }
        self.queueState.suspendedAfter = deadline
        
        context
            .commandHistory
            .setCommand(wait: deadline,
                        SuspendCommand(dispathOption: .unsafeSync) { [weak context,queueState] in
                            guard let context = context else { fatalError() }
                            context
                                .changeState(new: OperationSuspendState(context: context,
                                                                        queueState: queueState))
                            onSuspended.perform()
                        }
            )
    }
}
