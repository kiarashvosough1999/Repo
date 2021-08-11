//
//  OperationFinishState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

internal class OperationFinishState: OperationStateProtocol {
    
    internal weak var context: AsynchronousOperation?
    internal var isFinished: Bool { true }
    internal var isExecuting: Bool { false }
    internal var state: OperationState { .finished }
    internal var isCanceled: Bool = false
    internal var isSuspended: Bool = false
    internal var queueState: QueueState
    
    
    internal init(context: AsynchronousOperation? = nil, enqueued:Bool = false) {
        self.context = context
        self.queueState = QueueState(enqueued: enqueued)
    }
    
    func await(after: TimeInterval) throws {
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
            Operation with identifier: \(context.identifier) is already finished
            Could not be suspended
            """
        )
    }
    
    func cancelOperation(and execute: OperationCompletedSignal?) throws {
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
    
    internal func completeOperation() throws {
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
