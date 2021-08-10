//
//  OperationFinishState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

class OperationFinishState: OperationState {
    
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
            Operation with identifier: \(context.identifier) is already finished,
            """
        )
    }
    
    weak var context: AsynchronousOperation?
    var isFinished: Bool { true }
    var isExecuting: Bool { false }
}
