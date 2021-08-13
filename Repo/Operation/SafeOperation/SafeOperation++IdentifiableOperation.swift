//
//  SafeOperation++IdentifiableOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

extension SafeOperation: IdentifiableOperation {
    
    /// `Unique` identifier for this operation
    /// This identifier shold stay unique or it will results in crash or mis behavior
    /// if attemting to add or remove dependency
    public var identifier: OperationIdentifier {
        guard let name = name,
              let id = OperationIdentifier(rawValue: name) else {
            fatalError("operation has no identifier")
        }
        return id
    }
}

public protocol IdentifiableOperation: AnyObject {
    var identifier: OperationIdentifier { get }
}
