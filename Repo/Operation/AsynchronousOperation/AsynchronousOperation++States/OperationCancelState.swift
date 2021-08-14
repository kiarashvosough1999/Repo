//
//  OperationCancelState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

internal class OperationCancelState: OperationStateProtocol {
    
    internal weak var context: Context?
    internal var isFinished: Bool { true }
    internal var isExecuting: Bool { false }
    internal var state: OperationState { .canceled }
    internal var isCanceled: Bool = true
    internal var isSuspended: Bool = false
    internal var queueState: QueueState
    
    
    required internal init(context: Context? = nil, queueState: QueueState) {
        self.context = context
        self.queueState = queueState
        self.queueState.enqueued = false
//        self.context?.cancelRunnable()
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
            Operation with identifier: \(context.identifier) is already canceled,
            and could not be suspended.
            """
        )
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
            Operation with identifier: \(context.identifier) is already canceled,
            and could not be awaited.
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
        throw OperationControllerError.operationAlreadyCanceled(
            """
            Operation with identifier: \(context.identifier) is already canceled
            """
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
            Operation with identifier: \(context.identifier) is already canceled,
            and could not be completed.
            """
        )
    }
}
