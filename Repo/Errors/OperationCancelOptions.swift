//
//  OperationCancelOptions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

public enum OperationCancelOptions {
    case cancelAllOperation(SessionCancelOptions)
    case cancelReadyOperation(execpt: [OperationIdentifier])
    case cancelReadyOperationsAndWait
    case cancelExecutingOperation(execpt: [OperationIdentifier])
}
