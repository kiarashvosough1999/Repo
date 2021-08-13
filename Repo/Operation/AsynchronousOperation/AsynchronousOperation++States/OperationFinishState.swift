//
//  OperationFinishState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

internal class OperationFinishState<Context>: OperationStateProtocol where Context:StateFullOperation {
    
    internal weak var context: Context?
    internal var isFinished: Bool { true }
    internal var isExecuting: Bool { false }
    internal var state: OperationState { .finished }
    internal var isCanceled: Bool = false
    internal var isSuspended: Bool = false
    internal var queueState: QueueState
    
    
    required internal init(context: Context?, queueState: QueueState) {
        self.context = context
        self.queueState = QueueState(enqueued: queueState.enqueued)
    }
    
    func await(after deadline: TimeInterval) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        throw OperationControllerError.operationIsNotExecutingToFinish(
            """
            Operation with identifier: \(context.identifier) is already finished
            Could not be awaited
            """
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
            Operation with identifier: \(context.identifier) is already finished
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
            Operation with identifier: \(context.identifier) is already finished
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
        throw OperationControllerError.operationIsNotExecutingToFinish(
            """
            Operation with identifier: \(context.identifier) is already finished
            Could not be canceled
            """
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
        throw OperationControllerError.operationIsNotExecutingToFinish(
            """
            Operation with identifier: \(context.identifier) is already finished,
            Could not be finished again
            """
        )
    }
}
