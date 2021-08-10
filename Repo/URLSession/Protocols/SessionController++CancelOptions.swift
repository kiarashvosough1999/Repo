//
//  SessionController++CancelOptions.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

extension SessionController {
    
    public enum OperationCancelOptions {
        case cancelAllOperation(SessionCancelOptions)
        case cancelReadyOperation(execpt: [OperationIdentifier])
        case cancelReadyOperationsAndWait
        case cancelExecutingOperation(execpt: [OperationIdentifier])
    }
    
    public enum SessionCancelOptions {
        public  typealias completionHandler = () -> Void
        case invalidateAndCancel
        case reset(completionHandler)
        case flush(completionHandler)
        case none
    }
}
