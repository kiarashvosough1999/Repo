//
//  OperationSuspendState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/19/1400 AP.
//

import Foundation

internal class OperationSuspendState: OperationStateProtocol {
    
    internal weak var context: AsynchronousOperation?
    
    internal var isExecuting: Bool { false }
    
    internal var isFinished: Bool { false }
    
    internal var enqueued: Bool = false
    
    internal var state: OperationState { .suspended }
    
    internal var isCanceled: Bool = true
    
    internal var isSuspended: Bool = true
    
    internal var queueState: QueueState
    
    
    internal init(context: AsynchronousOperation? = nil, queueState: QueueState) {
        self.context = context
        self.queueState = queueState
    }
    
    func await(after deadline: TimeInterval) throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        try context
            .changeState(new: OperationReadyState(context: context,
                                                  queueState: queueState))
            .await(after: deadline)
    }
}
