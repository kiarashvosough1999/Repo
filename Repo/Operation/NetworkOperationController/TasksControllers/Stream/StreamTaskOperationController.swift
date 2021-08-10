//
//  StreamTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

public class StreamTaskOperationController: AsynchronousOperation,
                                            StreamTaskOperationControllerProtocol {
    
    public typealias TaskConfiguration = StreamTaskConfig
    
    public var taskConfiguration: StreamTaskConfig
    
    public var autoUpdateTaskConfigOnChange: Bool
    
    private var task: URLSessionStreamTask? {
        didSet {
            if task == nil, !state.isFinished , state.isExecuting {
                _ = try? self.cancelOperation()
            }
        }
    }
    
    public var sessionTask: URLSessionStreamTask? {
        get {
            task
        }
    }
    
    public init(operationQueue: OperationQueue?,
                sessionTask: @autoclosure () -> (StreamTaskOperationController.SessionTask),
                operationConfig: OperationConfig,
                autoUpdateTaskConfigOnChange:Bool = true,
                streamTaskConfig: StreamTaskConfig = StreamTaskConfig()) {
        self.autoUpdateTaskConfigOnChange = autoUpdateTaskConfigOnChange
        self.taskConfiguration = streamTaskConfig
        self.task = sessionTask()
        super.init(operationQueue: operationQueue,
                   operationConfiguration: operationConfig)
    }

    
    @discardableResult
    public func changeTaskConfiguration(_ config: (inout StreamTaskConfig) -> Void) -> Self {
        config(&self.taskConfiguration)
        if autoUpdateTaskConfigOnChange { applyTaskConfiguration() }
        return self
    }
    
    @discardableResult
    public func applyTaskConfiguration() -> Self {
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
    
    @discardableResult
    public func readData(ofMinLength minBytes: Int,
                  maxLength maxBytes: Int,
                  timeout: TimeInterval,
                  completionHandler: @escaping (Data?, Bool, Error?) -> Void)  -> Self {
        sessionTask?.readData(ofMinLength: minBytes,
                              maxLength: minBytes,
                              timeout: timeout,
                              completionHandler: completionHandler)
        return self
    }
    
    @discardableResult
    public func write(_ data: Data, timeout: TimeInterval, completionHandler: @escaping (Error?) -> Void)  -> Self {
        sessionTask?.write(data, timeout: timeout, completionHandler: completionHandler)
        return self
    }
    
    @discardableResult
    public func captureStreams()  -> Self {
        sessionTask?.captureStreams()
        return self
    }
    
    @discardableResult
    public func closeWrite()  -> Self {
        sessionTask?.closeWrite()
        return self
    }
    
    @discardableResult
    public func closeRead() -> Self {
        sessionTask?.closeRead()
        return self
    }
    
    @discardableResult
    public func startSecureConnection() -> Self {
        sessionTask?.startSecureConnection()
        return self
    }
    
    @available(iOS, introduced: 7.0, deprecated: 13.0, message: "TLS cannot be disabled once it is enabled")
    @discardableResult
    public func stopSecureConnection() -> Self {
        sessionTask?.stopSecureConnection()
        return self
    }
}

extension StreamTaskOperationController {
    
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
