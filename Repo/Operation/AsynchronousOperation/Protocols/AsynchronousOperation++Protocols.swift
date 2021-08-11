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
    
    @discardableResult
    func setOperationCompletedSignal(_ sig: OperationCompletedSignal?) -> Self
    
    @discardableResult
    func changeOperationConfig(_ config:ConfigurationCallBack<OperationConfig>) throws -> Self
    
    @discardableResult
    func completeOperation() throws -> Self
    
    @discardableResult
    func cancelOperation() throws -> Self
    
    @discardableResult
    func await(after: TimeInterval) throws -> Self
    
    @discardableResult
    func suspend(after:TimeInterval) throws -> Self
    
    @discardableResult
    func dependsOnOperation(with identifier: OperationIdentifier) throws -> Self
    
    @discardableResult
    func removeDependency(with identifier: OperationIdentifier) throws -> Self
    
    @discardableResult
    func removeDependency(with name: String) throws -> Self
    
    @discardableResult
    func removeDependencyAndCancelTraget(with name: String) throws -> Self
    
    @discardableResult
    func dependsOn(_ op: Operation) throws -> Self
    
    @discardableResult
    func removeDependencyAndCancel(with name: String) throws -> Self
    
}
