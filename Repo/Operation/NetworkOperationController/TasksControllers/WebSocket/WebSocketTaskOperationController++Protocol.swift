//
//  WebSocketTaskOperationController++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation

public protocol WebSocketTaskOperationControllerProtocol:TaskOperationControllerProtocol
where SessionTask == URLSessionWebSocketTask,
      TaskConfiguration:WebSocketTaskConfigurationProtocol {
    
    func sendPing(pongReceiveHandler: @escaping (Error?) -> Void) -> Self
    
    func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) -> Self
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) -> Self
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) -> Self
    
    var maximumMessageSize: Int? { get }
    
    var closeCode: URLSessionWebSocketTask.CloseCode? { get }
    
    var closeReason: Data? { get }
}

public protocol WebSocketTaskConfigurationProtocol: URLSessionAnyTaskConfigurationProtocol {
    var maximumMessageSize: Int { get set }
}
