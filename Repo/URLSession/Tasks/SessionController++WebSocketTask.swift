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
    public func startWebSocketTask<T>(with route: EndPoint,
                                      options: OperationConfig = OperationConfig())
    throws -> some WebSocketTaskOperationControllerProtocol where EndPoint: EndPointSocketType{
        try createTask { session, _ -> WebSocketTaskOperationController in
            let task = session.webSocketTask(with: route.url)
            return WebSocketTaskOperationController(operationQueue: tasksOperationQueue,
                                                    sessionTask: task,
                                                    operationConfig: options)
        }
        
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func startWebSocketTask<T>(with route: EndPoint,
                                      requestBuilder: T,
                                      options: OperationConfig = OperationConfig()) throws
    -> some WebSocketTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                           EndPoint: EndPointSocketType,
                                                           T.EndPoint == EndPoint {
        try createTask { session, _ -> WebSocketTaskOperationController in
            let task = try session.webSocketTask(with: requestBuilder.buildRequest(from: route))
            return  WebSocketTaskOperationController(operationQueue: tasksOperationQueue,
                                                     sessionTask: task,
                                                     operationConfig: options)
        }
        
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func startWebSocketTask<T>(urlprotocols with: EndPoint,
                                      options: OperationConfig = OperationConfig()) throws
    -> some WebSocketTaskOperationControllerProtocol where EndPoint: EndPointSocketType{
        try createTask { session, _ -> WebSocketTaskOperationController in
            let task = session.webSocketTask(with: with.url, protocols: with.protocols)
            return WebSocketTaskOperationController(operationQueue: tasksOperationQueue,
                                                    sessionTask: task,
                                                    operationConfig: options)
        }
        
    }
    
}
