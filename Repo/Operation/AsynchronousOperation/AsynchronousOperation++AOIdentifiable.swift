//
//  AsynchronousOperation++AsynchronousOperationIdentifiable.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public protocol AsynchronousOperationProtocol: AnyObject {
    
    typealias ConfigurationCallBack<T> = (inout T) -> ()
    typealias OperationCompletedSignal = () -> Void
    
    var operationCompletedSignal:OperationCompletedSignal? { get set }
    var identifier: OperationIdentifier { get }
    var _executing: Bool { get }
    var _finished: Bool { get }
    var state: OperationState { get }
    
    func changeOperationConfig(_ config:ConfigurationCallBack<OperationConfig>) throws -> Self
    func completeOperation() throws -> Self
    func cancelOperation() throws -> Self
    func await(after: TimeInterval) throws -> Self
    func dependsOnOperation(with identifier: OperationIdentifier) throws -> Self
    func removeDependency(with identifier: OperationIdentifier) throws -> Self
    func removeDependency(with name: String) throws -> Self
    func removeDependencyAndCancelTraget(with name: String) throws -> Self
    func dependsOn(_ op: Operation) throws -> Self
    func removeDependencyAndCancel(with name: String) throws -> Self
    
}
