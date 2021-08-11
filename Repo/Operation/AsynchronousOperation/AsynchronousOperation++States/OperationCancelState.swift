//
//  OperationCancelState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

internal class OperationCancelState: OperationStateProtocol {
    
    internal weak var context: AsynchronousOperation?
    internal var isFinished: Bool { true }
    internal var isExecuting: Bool { false }
    internal var state: OperationState { .canceled }
    internal var isCanceled: Bool = true
    internal var isSuspended: Bool = false
    internal var queueState: QueueState
    
    
    internal init(context: AsynchronousOperation? = nil, queueState: QueueState) {
        self.context = context
        self.queueState = queueState
    }
    
    func start() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        try queueState.willEnqueue.accept {
            throw OperationControllerError.cancelDuringWaitingForDeadline(
                """
                Operation with identifier: \(context.identifier) was canceled
                when it was waiting to be enqueued after its \(queueState.enqueuedAfter) sec deadline.
                """
            )
        }
        throw OperationControllerError.operationAlreadyCanceled(
            """
            Operation with identifier: \(context.identifier) was canceled,
            and could not be started again
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
            Operation with identifier: \(context.identifier) is already canceled,
            and could not be suspended.
            """
        )
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
            Operation with identifier: \(context.identifier) is already canceled,
            and could not be awaited.
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
            Operation with identifier: \(context.identifier) is already canceled,
            and could not be completed.
            """
        )
    }
}
