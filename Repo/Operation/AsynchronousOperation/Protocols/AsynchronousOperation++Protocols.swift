//
//  AsynchronousOperation++AsynchronousOperationIdentifiable.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public typealias OperationCompletedSignal = () -> Void

public protocol IdentifiableOperation: AnyObject {
    var identifier: OperationIdentifier { get }
}

public protocol AsynchronousOperationProtocol: IdentifiableOperation {
    
    typealias ConfigurationCallBack<T> = (inout T) -> ()
    
    var state:OperationStateBase { get }
    
    func setOperationCompletedSignal(_ sig: OperationCompletedSignal?) -> Self
    func changeOperationConfig(_ config:ConfigurationCallBack<OperationConfig>) throws -> Self
    func completeOperation() throws -> Self
    func cancelOperation() throws -> Self
    func await(after: TimeInterval) throws -> Self
    func suspend(after:TimeInterval) throws -> Self
    func dependsOnOperation(with identifier: OperationIdentifier) throws -> Self
    func removeDependency(with identifier: OperationIdentifier) throws -> Self
    func removeDependency(with name: String) throws -> Self
    func removeDependencyAndCancelTraget(with name: String) throws -> Self
    func dependsOn(_ op: Operation) throws -> Self
    func removeDependencyAndCancel(with name: String) throws -> Self
    
}
