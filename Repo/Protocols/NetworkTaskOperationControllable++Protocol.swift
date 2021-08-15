//
//  NetworkTaskOperationControllable++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

public protocol NetworkTaskOperationControllable: NetworkTaskOperationControllableBase {
    
    associatedtype SessionTask: URLSessionTask
    associatedtype TaskConfiguration: URLSessionAnyTaskConfigurationProtocol
    
    typealias SessionTaskBlock = () -> (SessionTask)
    
    func applyTaskConfiguration() -> Self
    func changeTaskConfiguration(_ config: (inout TaskConfiguration) -> Void) -> Self
}
