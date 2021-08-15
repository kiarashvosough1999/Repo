//
//  WebSocketTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

final public class NetworkWebSocketTaskOperationController: NetworkOperationController<URLSessionWebSocketTask,WebSocketTaskConfig> {
    
    @discardableResult
    public override func applyTaskConfiguration() -> Self {
        super.applyTaskConfiguration()
        self.maximumMessageSize = taskConfiguration.maximumMessageSize
        return self
    }
}

extension NetworkWebSocketTaskOperationController: WebSocketTaskOperationControllerProtocol {
    
    public private(set) var maximumMessageSize: Int? {
        get {
            task?.maximumMessageSize
        }
        set {
            task?.maximumMessageSize = newValue.or(.max)
        }
    }
    
    public var closeCode: URLSessionWebSocketTask.CloseCode? {
        task?.closeCode
    }
    
    public var closeReason: Data? {
        task?.closeReason
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    @discardableResult
    public func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) -> Self {
        task?.send(message, completionHandler: completionHandler)
        return self
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    @discardableResult
    public func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) -> Self {
        task?.receive(completionHandler: completionHandler)
        return self
    }
    
    @discardableResult
    public func sendPing(pongReceiveHandler: @escaping (Error?) -> Void) -> Self {
        task?.sendPing(pongReceiveHandler:pongReceiveHandler)
        return self
    }
    
    @discardableResult
    public func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) -> Self {
        task?.cancel(with: closeCode, reason: reason)
        return self
    }
}
