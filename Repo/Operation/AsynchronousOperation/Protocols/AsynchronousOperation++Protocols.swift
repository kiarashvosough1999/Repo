//
//  AsynchronousOperation++AsynchronousOperationIdentifiable.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public typealias OperationCompletedSignal = () -> Void

protocol CommandExecutable:AnyObject {
    var commandHistory: CommandHistory { get }
}

public protocol AsynchronousOperationProtocol: IdentifiableOperation,
                                               OperationDependencyProtocol,
                                               ControlableOperation {
    
    typealias ConfigurationCallBack<T> = (inout T) -> ()
    
    var state:OperationState { get }
    
    @discardableResult
    func setOperationCompletedSignal(_ sig: OperationCompletedSignal?) -> Self
    
    @discardableResult
    func changeOperationConfig(_ config:ConfigurationCallBack<OperationConfig>) throws -> Self
    
}
