//
//  DataTaskOperationControllerProtocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation

public protocol DataTaskOperationControllerProtocol: TaskOperationControllerProtocol where SessionTask == URLSessionDataTask,
TaskConfiguration: DataTaskConfigurationProtocol{
    
    var HTTPURLResponse:HTTPURLResponse? { get }
}

public protocol DataTaskConfigurationProtocol: URLSessionAnyTaskConfigurationProtocol { }
