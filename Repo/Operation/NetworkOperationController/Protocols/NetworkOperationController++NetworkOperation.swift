//
//  NetworkOperationController++NetworkOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public protocol TaskOperationControllerProtocol: TaskOperationControllerBaseProtocol {
    
    associatedtype SessionTask: URLSessionTask
    associatedtype TaskConfiguration: URLSessionAnyTaskConfigurationProtocol
    
    typealias SessionTaskBlock = () -> (SessionTask)
    
    var taskConfiguration:TaskConfiguration { get }
    var autoUpdateTaskConfigOnChange:Bool { get set }
    
    func applyTaskConfiguration() -> Self
    func changeTaskConfiguration(_ config: (inout TaskConfiguration) -> Void) -> Self
}
