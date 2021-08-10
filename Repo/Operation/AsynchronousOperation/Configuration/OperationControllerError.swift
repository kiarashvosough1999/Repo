//
//  OperationControllerError.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

enum OperationControllerError:Error {
    case canNotCompleteTask(String)
    case operationQueueIsNil(String)
    case misUseError(String)
    case operationNotFound(String)
    case canNotAddDependency(String)
    case operationAlreadyCanceled(String)
    case operationIsNotExecutingToFinish(String)
    case dealocatedOperation(String)
}
