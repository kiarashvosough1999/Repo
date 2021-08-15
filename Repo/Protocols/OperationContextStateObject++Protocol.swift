//
//  OperationContextStateObject++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

protocol OperationContextStateObject: AnyObject {
    
    var operationState: OperationStateProtocol { get }
    
    /// This method should be called whenever the state of the operation is going to change
    /// - Parameter state: Should provide new state
    @discardableResult
    func changeState(new state: OperationStateProtocol) -> OperationStateProtocol
}
