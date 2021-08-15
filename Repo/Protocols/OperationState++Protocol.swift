//
//  OperationState++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

protocol OperationStateBase: AnyObject {}

protocol OperationStateProtocol: OperationStateBase {
    
    typealias Context = CommandExecutable &
        ConfigurableOperation &
        OperationCycleProtocol &
        OperationContextStateObject &
        IdentifiableOperation &
        ControlableOperation
    
    init(context: Context?, queueState:QueueState)
    
    /// A delegate to AsynchronousOperation for handeling state chnages
    var context: Context? { get set }
    
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
    ///   - execute: suspend block which will be executed after changing the state.
    /// - Throws:
    ///   - `OperationControllerError.nilBlock ` when `execute` is nil.
    ///   - `OperationControllerError.dealocatedOperation` when context is nil.
    func suspend(after deadline: TimeInterval, execute: WorkerItem?) throws
}

extension OperationStateProtocol {
    
    var canModifyOperationConfig: Bool {
        !isExecuting && !isFinished && !isSuspended
    }
}
