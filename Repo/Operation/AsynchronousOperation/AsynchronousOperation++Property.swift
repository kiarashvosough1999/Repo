//
//  AsynchronousOperation++Getters.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/20/1400 AP.
//

import Foundation

extension AsynchronousOperation {
    
    /// Overridable property indicating whether the operation is `async` or not
    public override var isAsynchronous: Bool { return true }
    
    public var state: OperationStateBase { operationState }
    
    /// `Unique` identifier for this operation
    /// This identifier shold stay unique or it will results in crash or mis behavior
    /// if attempting to add or remove dependency
    public var identifier: OperationIdentifier {
        guard let name = name,
              let id = OperationIdentifier(rawValue: name) else {
            fatalError("operation has no identifier")
        }
        return id
    }
    
}
