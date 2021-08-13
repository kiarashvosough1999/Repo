//
//  AOState++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

/// An enum indicating Operation's State
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
    
    /// Indicating whether user can change the operation configuration or not.
    /// This getter will return true only if the operation state is on `ready`
    var canModifyOperationConfig: Bool { get }
    
    /// Complete operation by calling
    /// 1. `onFinish` block
    /// 2. Changing state to `OperationFinishState`
    /// - Parameter execute: onFinish block which was provoded by overriding it on subclasses
    /// - Throws: OperationControllerError.dealocatedOperation or
    func completeOperation(and execute:WorkerItem?) throws
    
    /// Call this method when you want to start the operation and your task
    /// default implementation calls main() on operation and change state to executing
    /// also the `start` method on operation should call this method
    func start() throws
    
    func await(after deadline:TimeInterval) throws
    
    func cancelOperation(and execute: WorkerItem?) throws
    
    /// Suspend should only be called on download or upload task.
    /// Calling this method on other tasksmay result in crash, leak and unexpected usage of network data.
    /// - Parameters:
    ///   - deadline: execute suspend request after an amount of time.
    ///   - execute: suspend block which will be executed before changing the state.
    /// - Throws:
    ///   - `OperationControllerError.nilBlock ` when `execute` is nil.
    ///   - `OperationControllerError.dealocatedOperation` when context is nil.
    func suspend(after deadline: TimeInterval, execute: WorkerItem?) throws
}

protocol OperationStateProtocol: OperationStateBase {
    
    associatedtype Context: StateFullOperation & AnyObject
    
    init(context: Context?, queueState:QueueState)
    
    /// A delegate to AsynchronousOperation for handeling state chnages
    var context: Context? { get set }
}

extension OperationStateBase {
    
    var canModifyOperationConfig: Bool {
        !isExecuting && !isFinished && !isSuspended
    }
    
//    func suspend(after deadline: TimeInterval, execute: OperationCompletedSignal?) throws {
//        guard let context = context else {
//            throw OperationControllerError.dealocatedOperation(
//                """
//                context was dealocated on\(String(describing: self)), cannot change state
//                """
//            )
//        }
//        if isFinished {
//            throw OperationControllerError.operationAlreadyCanceled(
//                """
//                Operation with identifier: \(context.identifier) is already finished
//                and cant be suspend
//                """
//            )
//        }
//        else if !isExecuting {
//            throw OperationControllerError.operationAlreadyCanceled(
//                """
//                Operation with identifier: \(context.identifier) is not executing
//                and cant be suspend
//                """
//            )
//        }
//    }
//
//    func cancelOperation(and execute: OperationCompletedSignal?) throws {
//        guard let context = context else {
//            throw OperationControllerError.dealocatedOperation(
//                """
//                context was dealocated on\(String(describing: self)), cannot change state
//                """
//            )
//        }
//        throw OperationControllerError.operationAlreadyCanceled(
//            """
//            Operation with identifier: \(context.identifier) is already canceled
//            """
//        )
//    }
//
//    func completeOperation(and execute: OperationCompletedSignal?) throws {
//        guard let context = context else {
//            throw OperationControllerError.dealocatedOperation(
//                """
//                context was dealocated on\(String(describing: self)), cannot change state
//                """
//            )
//        }
//        throw OperationControllerError.operationIsNotExecutingToFinish(
//            """
//            Operation with identifier: \(context.identifier) is already canceled and finished,
//            """
//        )
//    }
//
//    func start() throws {
//        guard !context.isNil else {
//            throw OperationControllerError.dealocatedOperation(
//                """
//                context was dealocated on\(String(describing: self)), cannot change state
//                """
//            )
//        }
//        throw OperationControllerError.misUseError(
//            " `start` function should just be called once by operationQueue when the aperation was added to the queue"
//        )
//    }
}

protocol OperationContextStateObject: AnyObject {
    
    var operationState: OperationStateBase! { get }
    
    /// This method should be called whenever the state of the operation is going to change
    /// - Parameter state: Should provide new state
    func changeState(new state: OperationStateBase) -> OperationStateBase
}
