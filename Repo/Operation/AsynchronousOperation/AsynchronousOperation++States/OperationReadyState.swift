//
//  OperationReadyState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

class OperationReadyState: OperationState {
    weak var context: AsynchronousOperation?
    var isFinished: Bool { false }
    var isExecuting: Bool { false }
    private var enqueued = false
    
    init(context: AsynchronousOperation?) {
        self.context = context
    }
    
    func cancelOperation() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        context.cancel()
    }
    
    func start() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        context.changeState(new: OperationExecutingState())
        context.main()
    }
    
    func completeOperation() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        try isExecuting.reject {
            throw OperationControllerError.operationIsNotExecutingToFinish(
                """
                Operation with identifier: \(context.identifier) is not executing to finish,
                try to cancel it before execution
                """
            )
        }
    }
    
    func await() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        guard !enqueued  else {
            throw OperationControllerError.misUseError(
                "operation with identifier \(context.identifier) is already enqueued on a queue"
            )
        }
        try context.operationQueue.on { operationQueue in
            operationQueue.addOperation(context)
            enqueued = true
//            context.changeState(new: OperationExecutingState())
        } none: {
            throw OperationControllerError.operationQueueIsNil(
                """
                operationQueue on operation with identifier: \(context.identifier)
                    was found nil,can not add this operation to execute
                """)
        }
        // block the current thread until all operation finish
        // new operation cant be added to queue during this block time
        context.operationConfiguration
            .waitUntilAllOperationsAreFinished.accept {
                context.operationQueue?.waitUntilAllOperationsAreFinished()
            }
    }
}
