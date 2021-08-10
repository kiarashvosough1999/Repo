//
//  WebSocketTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

final public class WebSocketTaskOperationController: AsynchronousOperation, WebSocketTaskOperationControllerProtocol {
    
    public typealias TaskConfiguration = WebSocketTaskConfig
    
    public var taskConfiguration: WebSocketTaskConfig {
        didSet {
            if autoUpdateTaskConfigOnChange { applyTaskConfiguration() }
        }
    }
    
    private var task: SessionTask? {
        didSet {
            if task == nil, !state.isFinished , state.isExecuting {
                _ = try? self.cancelOperation()
            }
        }
    }
    
    public var sessionTask: URLSessionWebSocketTask? {
        return task
    }
    
    public var autoUpdateTaskConfigOnChange:Bool
    
    public private(set) var maximumMessageSize: Int? {
        get {
            sessionTask?.maximumMessageSize
        }
        set {
            sessionTask?.maximumMessageSize = newValue.or(.max)
        }
    }
    
    public var closeCode: URLSessionWebSocketTask.CloseCode? {
        sessionTask?.closeCode
    }
    
    public var closeReason: Data? {
        sessionTask?.closeReason
    }
    
    public init(operationQueue: OperationQueue?,
                sessionTask: @autoclosure () -> (WebSocketTaskOperationController.SessionTask),
                operationConfig: OperationConfig,
                autoUpdateTaskConfigOnChange:Bool = true,
                webSocketTaskConfig: WebSocketTaskConfig = WebSocketTaskConfig()) {
        self.autoUpdateTaskConfigOnChange = autoUpdateTaskConfigOnChange
        self.taskConfiguration = webSocketTaskConfig
        self.task = sessionTask()
        super.init(operationQueue: operationQueue,
                   operationConfiguration: operationConfig)
    }
    
    @discardableResult
    public func applyTaskConfiguration() -> Self {
        self.maximumMessageSize = taskConfiguration.maximumMessageSize
        self.taskDescription = taskConfiguration.taskDescription
        if #available(iOS 11.0, *) {
            self.earliestBeginDate = taskConfiguration.earliestBeginDate
            self.countOfBytesClientExpectsToSend = taskConfiguration.countOfBytesClientExpectsToSend
            self.countOfBytesClientExpectsToReceive = taskConfiguration.countOfBytesClientExpectsToReceive
        }
        if #available(iOS 14.5, *) {
            self.prefersIncrementalDelivery = taskConfiguration.prefersIncrementalDelivery
        }
        if #available(iOS 8.0, *) {
            self.priority = taskConfiguration.priority
        }
        return self
    }
    
    @discardableResult
    public func changeTaskConfiguration(_ config: (inout WebSocketTaskConfig) -> Void) -> Self {
        config(&self.taskConfiguration)
        if autoUpdateTaskConfigOnChange { applyTaskConfiguration() }
        return self
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    @discardableResult
    public func send(_ message: URLSessionWebSocketTask.Message, completionHandler: @escaping (Error?) -> Void) -> Self {
        sessionTask?.send(message, completionHandler: completionHandler)
        return self
    }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    @discardableResult
    public func receive(completionHandler: @escaping (Result<URLSessionWebSocketTask.Message, Error>) -> Void) -> Self {
        sessionTask?.receive(completionHandler: completionHandler)
        return self
    }
    
    @discardableResult
    public func sendPing(pongReceiveHandler: @escaping (Error?) -> Void) -> Self {
        sessionTask?.sendPing(pongReceiveHandler:pongReceiveHandler)
        return self
    }
    
    @discardableResult
    public func cancel(with closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) -> Self {
        sessionTask?.cancel(with: closeCode, reason: reason)
        return self
    }
    
    @discardableResult
    public override func completeOperation() throws -> Self {
        try super.completeOperation()
        task = nil
        return self
    }
    
    @discardableResult
    public override func cancelOperation() throws -> Self {
        task?.cancel()
        task = nil
        try super.cancelOperation()
        return self
    }
    
    public override func main() {
        task?.resume()
    }
    
    public override func cancel() {
        task?.cancel()
        task = nil
        super.cancel()
    }
}

extension WebSocketTaskOperationController {
    
    public private(set) var taskDescription: String? {
        get {
            sessionTask?.taskDescription
        }
        set {
            sessionTask?.taskDescription = newValue
        }
    }
    
    public var taskState: URLSessionTask.State? { sessionTask?.state }
    
    @available(iOS 7.0, *)
    public var progress: Progress? { sessionTask?.progress }
    
    public var taskIdentifier: Int? { sessionTask?.taskIdentifier }
    
    public var originalRequest: URLRequest? { sessionTask?.originalRequest }
    
    public var currentRequest: URLRequest? { sessionTask?.currentRequest }
    
    public var response: URLResponse? { sessionTask?.response }
    
    @available(iOS 11.0, *)
    public private(set) var earliestBeginDate: Date? {
        get {
            sessionTask?.earliestBeginDate
        }
        set {
            sessionTask?.earliestBeginDate = newValue
        }
    }
    
    @available(iOS 11.0, *)
    public private(set) var countOfBytesClientExpectsToSend: Int64? {
        get {
            sessionTask?.countOfBytesClientExpectsToSend
        }
        set {
            sessionTask?.countOfBytesClientExpectsToSend = newValue.or(NSURLSessionTransferSizeUnknown)
        }
    }
    
    @available(iOS 11.0, *)
    public private(set) var countOfBytesClientExpectsToReceive: Int64? {
        get {
            sessionTask?.countOfBytesClientExpectsToReceive
        }
        set {
            sessionTask?.countOfBytesClientExpectsToReceive = newValue.or(NSURLSessionTransferSizeUnknown)
        }
    }
    
    public var countOfBytesReceived: Int64? { sessionTask?.countOfBytesReceived }
    
    public var countOfBytesSent: Int64? { sessionTask?.countOfBytesSent }
    
    public var countOfBytesExpectedToSend: Int64? { sessionTask?.countOfBytesExpectedToSend }
    
    public var countOfBytesExpectedToReceive: Int64? { sessionTask?.countOfBytesExpectedToReceive }
    
    public var error: Error? { sessionTask?.error }
    
    @available(iOS 8.0, *)
    public private(set) var priority: Float? {
        get {
            sessionTask?.priority
        }
        set {
            sessionTask?.priority = newValue.or(URLSessionTask.defaultPriority)
        }
    }
    
    @available(iOS 14.5, *)
    public private(set) var prefersIncrementalDelivery: Bool? {
        get {
            sessionTask?.prefersIncrementalDelivery
        }
        set {
            sessionTask?.prefersIncrementalDelivery = newValue.or(false)
        }
    }
}
