//
//  AOState++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

public protocol OperationState {
    var context: AsynchronousOperation? { get set }
    var isExecuting: Bool { get }
    var isFinished: Bool { get }
    var canModifyOperationConfig: Bool { get }
    func completeOperation() throws
    func start() throws
    func await(after:TimeInterval) throws
    func cancelOperation() throws
}

public extension OperationState {
    
    var canModifyOperationConfig: Bool {
        !isExecuting && !isFinished
    }
    
    func cancelOperation() throws {
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
    
    func completeOperation() throws {
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
    var state: OperationState { get }
    func changeState(new state: OperationState)
}
