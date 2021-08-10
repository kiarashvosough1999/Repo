//
//  OperationExecutingState.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

class OperationExecutingState: OperationState {

    weak var context: AsynchronousOperation?
    var isFinished: Bool { false }
    var isExecuting: Bool { true }
    
    func completeOperation() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        context.changeState(new: OperationFinishState())
    }
    
    func cancelOperation() throws {
        guard let context = context else {
            throw OperationControllerError.dealocatedOperation(
                """
                context was dealocated on\(String(describing: self)), cannot change state
                """
            )
        }
        context.changeState(new: OperationCancelState())
        context.cancel()
    }
    
}
