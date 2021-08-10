//
//  AnyTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation


final public class AnyTaskOperationController<SessionTask:URLSessionTask>: AsynchronousOperation,
                                                                           TaskOperationControllerProtocol {
    
    
    public private(set) var taskConfiguration: URLSessionAnyTaskConfig
    
    public var autoUpdateTaskConfigOnChange: Bool
    
    public typealias TaskConfiguration = URLSessionAnyTaskConfig
    
    public typealias SessionTask = SessionTask
    
    private var task: SessionTask? {
        didSet {
            if task == nil, !state.isFinished , state.isExecuting {
                _ = try? self.cancelOperation()
            }
        }
    }
    
    public var sessionTask: SessionTask? {
        return task
    }
    
    public var taskDescription: String? {
        get {
            sessionTask?.taskDescription
        }
        set {
            sessionTask?.taskDescription = newValue
        }
    }
    
    
    init(operationQueue: OperationQueue?,
         sessionTask: @autoclosure SessionTaskBlock,
         autoUpdateTaskConfigOnChange: Bool = true,
         anyTaskConfig:URLSessionAnyTaskConfig = URLSessionAnyTaskConfig(),
         operationConfig: OperationConfig = OperationConfig()) {
        self.autoUpdateTaskConfigOnChange = autoUpdateTaskConfigOnChange
        self.task = sessionTask()
        self.taskConfiguration = anyTaskConfig
        super.init(operationQueue: operationQueue,
                   operationConfiguration: operationConfig)
    }
    
    //    init(operationQueue: OperationQueue?,
    //         taskWrapper: TaskWrapper<SessionTask>,
    //         operationConfig: OperationConfig) {
    //        super.init(operationQueue: operationQueue,
    //                   operationConfiguration: operationConfig,
    //                   operationConfig: operationConfig)
    //        do {
    //            self.task = try taskWrapper.task({ [weak self] in
    ////                guard let self = self else {
    ////                    throw OperationControllerError.canNotCompleteTask(
    ////                        "TaskOperationController was deinited before complete operation"
    ////                    )
    ////                }
    ////                _ = try self.completeOperation()
    //            })
    //        } catch {
    //            fatalError(error.localizedDescription)
    //        }
    //    }
    
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
    public func changeTaskConfiguration(_ config: (inout URLSessionAnyTaskConfig) -> Void) -> Self {
        config(&self.taskConfiguration)
        applyTaskConfiguration()
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

extension AnyTaskOperationController {
    
    public var taskState: URLSessionTask.State? { sessionTask?.state }
    
    public var progress: Progress? { sessionTask?.progress }
    
    public var taskIdentifier: Int? { sessionTask?.taskIdentifier }
    
    public var originalRequest: URLRequest? { sessionTask?.originalRequest }
    
    public var currentRequest: URLRequest? { sessionTask?.currentRequest }
    
    public var response: URLResponse? { sessionTask?.response }
    
    @available(iOS 11.0, *)
    public var earliestBeginDate: Date? {
        get {
            sessionTask?.earliestBeginDate
        }
        set {
            sessionTask?.earliestBeginDate = newValue
        }
    }
    
    @available(iOS 11.0, *)
    public var countOfBytesClientExpectsToSend: Int64? {
        get {
            sessionTask?.countOfBytesClientExpectsToSend
        }
        set {
            sessionTask?.countOfBytesClientExpectsToSend = newValue.or(NSURLSessionTransferSizeUnknown)
        }
    }
    
    @available(iOS 11.0, *)
    public var countOfBytesClientExpectsToReceive: Int64? {
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
    public var priority: Float? {
        get {
            sessionTask?.priority
        }
        set {
            sessionTask?.priority = newValue.or(URLSessionTask.defaultPriority)
        }
    }
    
    @available(iOS 14.5, *)
    public var prefersIncrementalDelivery: Bool? {
        get {
            sessionTask?.prefersIncrementalDelivery
        }
        set {
            sessionTask?.prefersIncrementalDelivery = newValue.or(false)
        }
    }
}
