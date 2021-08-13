//
//  OperationSuspendState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/19/1400 AP.
//

import Foundation

internal class OperationSuspendState<Context>: OperationStateProtocol where Context:StateFullOperation &
                                                                                CommandExecutable &
                                                                                ConfigurableOperation {
    
    internal weak var context: Context?
    
    internal var isExecuting: Bool { false }
    
    internal var isFinished: Bool { false }
    
    internal var enqueued: Bool = false
    
    internal var state: OperationState { .suspended }
    
    internal var isCanceled: Bool = true
    
    internal var isSuspended: Bool = true
    
    internal var queueState: QueueState
    
    
    required internal init(context: Context? = nil, queueState: QueueState) {
        self.context = context
        self.queueState = queueState
    }
    
    func await(after deadline: TimeInterval) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        let date = Date()
        context.commandHistory.set(
            AwaitCommand(on: context, [
                .init(dispathOption: .asyncAfterWithInheritedQueue(deadline: deadline),
                      block: { [weak context, queueState,date] in
                    guard let context = context else { fatalError() }
                    do {
                        print(Date().timeIntervalSince(date))
                        try context
                            .changeState(new: OperationReadyState(context: context,
                                                                  queueState: queueState))
                            .await(after: 0)
                    }catch {
                        print(error)
                    }
                })
            ])
        )
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
            Operation with identifier: \(context.identifier) is already Suspended
            Could not be started
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
            Operation with identifier: \(context.identifier) is already Suspended
            Could not be suspended
            """
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
        context.commandHistory.set(
            CancelCommand(on: context, [
                onCanceled,
                .init(dispathOption: .asyncWithInheritedQueue,
                      block: { [weak context, queueState] in
                        guard let context = context else { fatalError() }
                        context.changeState(new: OperationCancelState(context: context, queueState: queueState))
                      })
            ])
        )
    }
    
    internal func completeOperation(and execute: WorkerItem?) throws {
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
        context.commandHistory.set(
            CompeleteCommand(on: context, [
                onFinished,
                .init(dispathOption: .asyncWithInheritedQueue,
                      block: { [weak context,queueState] in
                        guard let context = context else { fatalError() }
                        context.changeState(new: OperationFinishState(context: context, queueState: queueState))
                      })
            ])
        )
    }
}
