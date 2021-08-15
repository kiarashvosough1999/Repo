//
//  NetworkAsyncOperatable++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

public typealias OperationCompletedSignal = () -> Void

public protocol NetworkAsyncOperatable: IdentifiableOperation,
                                               OperationDependencyProtocol,
                                               ControlableOperation {
    
    typealias ConfigurationCallBack<T> = (inout T) -> ()
    
    var state:OperationState { get }
    
    @discardableResult
    func setOperationCompletedSignal(_ sig: OperationCompletedSignal?) -> Self
}
