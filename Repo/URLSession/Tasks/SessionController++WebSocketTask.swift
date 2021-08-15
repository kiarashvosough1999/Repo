//
//  SessionController++WebSocketTask.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

extension SessionController {
    
    #warning("not ready to use")
    
    @available(iOS 13.0, *)
    @discardableResult
    public func webSocketTask<T>(with route: EndPoint,
                                 operationConfiguration: OperationConfiguration = OperationConfiguration())
    throws -> some WebSocketTaskOperationControllerProtocol where EndPoint: EndPointSocketType{
        try createTask { session, _ -> NetworkWebSocketTaskOperationController in
            let task = session.webSocketTask(with: route.url)
            return NetworkWebSocketTaskOperationController(operationQueue: tasksOperationQueue,
                                                           sessionTask: task,
                                                           configuration: operationConfiguration)
        }
        
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func webSocketTask<T>(with route: EndPoint,
                                 requestBuilder: T,
                                 operationConfiguration: OperationConfiguration = OperationConfiguration()) throws
    -> some WebSocketTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                           EndPoint: EndPointSocketType,
                                                           T.EndPoint == EndPoint {
        try createTask { session, _ -> NetworkWebSocketTaskOperationController in
            let task = try session.webSocketTask(with: requestBuilder.buildRequest(from: route))
            return  NetworkWebSocketTaskOperationController(operationQueue: tasksOperationQueue,
                                                            sessionTask: task,
                                                            configuration: operationConfiguration)
        }
        
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func webSocketTask<T>(urlprotocols with: EndPoint,
                                 operationConfiguration: OperationConfiguration = OperationConfiguration()) throws
    -> some WebSocketTaskOperationControllerProtocol where EndPoint: EndPointSocketType{
        try createTask { session, _ -> NetworkWebSocketTaskOperationController in
            let task = session.webSocketTask(with: with.url, protocols: with.protocols)
            return NetworkWebSocketTaskOperationController(operationQueue: tasksOperationQueue,
                                                           sessionTask: task,
                                                           configuration: operationConfiguration)
        }
        
    }
    
}
