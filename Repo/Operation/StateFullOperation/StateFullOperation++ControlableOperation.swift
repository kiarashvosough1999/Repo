//
//  SafeOperation++ControlableOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

public protocol ControlableOperation: AnyObject {
    
    @discardableResult
    func setOperationCompletedSignal(_ sig: OperationCompletedSignal?) -> Self
    
    @discardableResult
    func completeOperation() throws -> Self
    
    @discardableResult
    func cancelOperation() throws -> Self
    
    @discardableResult
    func suspend(after deadline: TimeInterval) throws -> Self
    
    @discardableResult
    func await(after deadline: TimeInterval) throws -> Self
}
