//
//  AOState++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

public enum OperationState {
    case ready
    case executing
    case finished
    case canceled
    case suspended
}

public protocol OperationStateBase: AnyObject {
    var isExecuting: Bool { get }
    var isFinished: Bool { get }
    var isCanceled: Bool { get }
    var isSuspended: Bool { get }
    var queueState: QueueState { get }
    var state: OperationState { get }
}

public protocol OperationStateProtocol: OperationStateBase {
    
    var context: AsynchronousOperation? { get set }
    var canModifyOperationConfig: Bool { get }
    
    func completeOperation(and execute:OperationCompletedSignal?) throws
    
    func start() throws
    
    func await(after:TimeInterval) throws
    
    func cancelOperation(and execute: OperationCompletedSignal?) throws
    
    func suspend(after: TimeInterval, execute: OperationCompletedSignal?) throws
}

public extension OperationStateProtocol {
    
    var canModifyOperationConfig: Bool {
        !isExecuting && !isFinished
    }
    
    func suspend(after: TimeInterval, execute: OperationCompletedSignal?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        if isFinished {
            throw OperationControllerError.operationAlreadyCanceled(
                """
                Operation with identifier: \(context.identifier) is already finished
                and cant be suspend
                """
            )
        }
        else if !isExecuting {
            throw OperationControllerError.operationAlreadyCanceled(
                """
                Operation with identifier: \(context.identifier) is not executing
                and cant be suspend
                """
            )
        }
    }
    
    func cancelOperation(and execute: OperationCompletedSignal?) throws {
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
    
    func completeOperation(and execute: OperationCompletedSignal?) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        throw OperationControllerError.operationIsNotExecutingToFinish(
            """
            Operation with identifier: \(context.identifier) is already canceled and finished,
            """
        )
    }
    
    func start() throws {
        guard !context.isNil else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        throw OperationControllerError.misUseError(
            " `start` function should just be called once by operationQueue when the aperation was added to the queue"
        )
    }
    
    func await(after:TimeInterval) throws {
        guard !context.isNil else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        throw OperationControllerError.misUseError("`await` function should just be called once")
    }
}

protocol OperationContextStateObject: AnyObject {
    var operationState: OperationStateProtocol { get }
    func changeState(new state: OperationStateProtocol) -> OperationStateProtocol
}
