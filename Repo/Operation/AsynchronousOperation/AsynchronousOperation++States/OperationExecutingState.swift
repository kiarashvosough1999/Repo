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
    
    #warning("handle suspend after amount of time")
    func suspend(after: TimeInterval, execute: OperationCompletedSignal?) throws {
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
        context.changeState(new: OperationSuspendState(context: context, queueState: queueState))
    }
    
}
