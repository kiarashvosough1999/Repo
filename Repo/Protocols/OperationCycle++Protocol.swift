//
//  OperationCycle++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation


internal protocol OperationCycleProtocol: AnyObject {
    
    var shouldCheckForCancelation: Bool { get }
    
    /// Blocks the current thread until all of the receiver’s queued and executing operations finish executing.

    /// When called, this method blocks the current thread and waits for the receiver’s current and queued operations to finish executing.
    /// While the current thread is blocked, the receiver continues to launch already queued operations and monitor those that are executing.
    /// During this time, the current thread cannot add operations to the queue, but other threads may. Once all of the pending operations are finished, this method returns.
    /// If there are no operations in the queue, this method returns immediately.
    func waitUntilAllOperationsAreFinished()
    
    
    /// ٍEnququ Self in `OperationQueue` to start
    /// This method should be called instead of `operationQueue.addOperation(self)`
    /// `operationQueue.addOperation(self)` was imeplemnted in super class with more safety
    ///  - Throws: queueFoundNil ---> if the `OperationQueue` is nil
    func enqueueSelf() throws
    
    /// Performs the receiver’s non-concurrent task.
    /// The default implementation of this method does nothing. You should override this method to perform the desired task.
    /// In your implementation, do not invoke super. This method will automatically execute within an autorelease pool provided by `SafeOperation`,
    ///  so you do not need to create your own autorelease pool block in your implementation.
    /// If you are implementing a concurrent operation,
    ///  you are not required to override this method but may do so if you plan to call it from your custom `shouldStartRunnable()` method.
    func runnable() throws
    
    /// Begins the execution of the operation before the runnable method being called.
    /// The default implementation of this method updates the execution state of the operation and calls the receiver’s `startRunnable()` method.
    /// This method also performs several checks to ensure that the operation can actually run if the `shouldCheckForCancelation` is true.
    ///  For example, if the receiver was cancelled or is already finished, this method simply returns without calling `startRunnable()`.
    /// An operation is not considered ready to execute if it is still dependent on other operations that have not yet finished.
    /// If you are implementing a concurrent operation, you must override this method and use it to initiate your operation.
    /// Your custom implementation must not call super at any time. In addition to configuring the execution environment for your task, your implementation of this method must also track the state of the operation and provide appropriate state transitions. When the operation executes and subsequently finishes its work, it should set new values for the isExecuting and isFinished respectively.
    /// it is a programmer error to call this method on an operation object that is already in an operation queue or to queue the operation after calling this method.
    /// Once you add an operation object to a queue, the queue assumes all responsibility for it.
    func shouldStartRunnable() throws
    
    /// Begins the execution of the operation
    /// The default implementation of this method calls the receiver’s `runnable()` method to start the desired tasks.
    func startRunnable() throws
    
    /// This method does not force your operation code to stop.
    /// Instead, it updates the object’s internal flags to reflect the change in state.
    /// If the operation has already finished executing, this method has no effect.
    /// Canceling an operation that is currently in an operation queue, but not yet executing,
    /// makes it possible to remove the operation from the queue sooner than usual.
    func cancelRunnable() throws
}
