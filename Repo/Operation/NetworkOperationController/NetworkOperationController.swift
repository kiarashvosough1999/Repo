//
//  OperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

public class NetworkOperationController<Task,Configuration>: NetworkAsyncOperation,
                                                      NetworkTaskOperationControllable where Task:URLSessionTask,
                                                                                            Configuration:URLSessionAnyTaskConfigurationProtocol{
    
    public typealias SessionTask = Task
    
    public typealias TaskConfiguration = Configuration
    
    internal private(set) var taskConfiguration: Configuration
    
    internal var task: SessionTask?
    
    private var autoUpdateTaskConfigOnChange: Bool
    
    @available(iOS 7.0, *)
    @objc public var progress: Progress? { task?.progress }
    
    override var onCanceled: StateFullOperation.WorkerItemBlock? {
        return {
            .init(dispathOption: .unsafeSync) { [weak self] in
                guard let self = self else { fatalError("Unable to execute cancel block") }
                self.task?.cancel()
                self.task.toggleNil()
                
            }
        }
    }
    
    override var onFinished: StateFullOperation.WorkerItemBlock? {
        return {
            .init(dispathOption: .unsafeSync) { [weak self] in
                guard let self = self else { fatalError("Unable to execute finish block") }
                self.task?.cancel()
                self.task.toggleNil()
            }
        }
    }
    
    override var onExecuting: StateFullOperation.WorkerItemBlock? {
        return {
            .init(dispathOption: .unsafeSync) { [weak self] in
                guard let self = self else { fatalError("Unable to execute executing block") }
                self.task?.resume()
            }
        }
    }
    
    
    init(operationQueue: OperationQueue,
         sessionTask: @autoclosure SessionTaskBlock,
         autoUpdateTaskConfigOnChange: Bool = true,
         taskConfig:Configuration = .init(),
         configuration: OperationConfiguration = .init()) {
        self.autoUpdateTaskConfigOnChange = autoUpdateTaskConfigOnChange
        self.task = sessionTask()
        self.taskConfiguration = taskConfig
        super.init(operationQueue: operationQueue, configuration: configuration)
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
    public func changeTaskConfiguration(_ config: (inout Configuration) -> Void) -> Self {
        config(&self.taskConfiguration)
        if autoUpdateTaskConfigOnChange { applyTaskConfiguration() }
        return self
    }
    
}

extension NetworkOperationController {
    
    public var taskDescription: String? {
        get {
            task?.taskDescription
        }
        set {
            task?.taskDescription = newValue
        }
    }
    
    public var taskState: URLSessionTask.State? { task?.state }
    
    public var taskIdentifier: Int? { task?.taskIdentifier }
    
    public var originalRequest: URLRequest? { task?.originalRequest }
    
    public var currentRequest: URLRequest? { task?.currentRequest }
    
    public var response: URLResponse? { task?.response }
    
    @available(iOS 11.0, *)
    public var earliestBeginDate: Date? {
        get {
            task?.earliestBeginDate
        }
        set {
            task?.earliestBeginDate = newValue
        }
    }
    
    @available(iOS 11.0, *)
    public var countOfBytesClientExpectsToSend: Int64? {
        get {
            task?.countOfBytesClientExpectsToSend
        }
        set {
            task?.countOfBytesClientExpectsToSend = newValue.or(NSURLSessionTransferSizeUnknown)
        }
    }
    
    @available(iOS 11.0, *)
    public var countOfBytesClientExpectsToReceive: Int64? {
        get {
            task?.countOfBytesClientExpectsToReceive
        }
        set {
            task?.countOfBytesClientExpectsToReceive = newValue.or(NSURLSessionTransferSizeUnknown)
        }
    }
    
    public var countOfBytesReceived: Int64? { task?.countOfBytesReceived }
    
    public var countOfBytesSent: Int64? { task?.countOfBytesSent }
    
    public var countOfBytesExpectedToSend: Int64? { task?.countOfBytesExpectedToSend }
    
    public var countOfBytesExpectedToReceive: Int64? { task?.countOfBytesExpectedToReceive }
    
    public var error: Error? { task?.error }
    
    @available(iOS 8.0, *)
    public var priority: Float? {
        get {
            task?.priority
        }
        set {
            task?.priority = newValue.or(URLSessionTask.defaultPriority)
        }
    }
    
    @available(iOS 14.5, *)
    public var prefersIncrementalDelivery: Bool? {
        get {
            task?.prefersIncrementalDelivery
        }
        set {
            task?.prefersIncrementalDelivery = newValue.or(false)
        }
    }
}
