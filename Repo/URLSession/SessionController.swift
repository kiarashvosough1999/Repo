//
//  SessionController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation
import Network

public final class SessionController<EndPoint:Hashable>: NSObject, SessionControllerProtocol {
    
    internal typealias TaskBuilder<T> = (URLSession, @escaping OnCompletion) throws -> T
    
    internal var urlSession:URLSession!
    internal var config:URLSessionConfiguration
    internal var delegateOperationQueue: OperationQueue?
    internal var tasksOperationQueue: OperationQueue
    internal var ops:[TaskOperationControllerBaseProtocol] = []
    internal var opss:[OperationIdentifier:TaskOperationControllerBaseProtocol] = [:]
    private var network: NWPathMonitor
    
    public init(config:URLSessionConfiguration = URLSessionConfiguration.default,
                delegateOperationQueue: OperationQueue = OperationQueue(),
                underlyingQueue:DispatchQueue? = nil,
                tasksOperationQueue: OperationQueue = OperationQueue()) {
        self.delegateOperationQueue = delegateOperationQueue
        self.tasksOperationQueue = tasksOperationQueue
        self.config = config
        self.network = NWPathMonitor()
        super.init()
        self.tasksOperationQueue.underlyingQueue = underlyingQueue.isNil ? DispatchQueue(label: "Session\(ObjectIdentifier(self))") : underlyingQueue
        startmonitoring()
    }
    
    deinit {
        network.cancel()
        tasksOperationQueue.cancelAllOperations()
        urlSession.invalidateAndCancel()
    }
    
    public func executeCancel(with option: OperationCancelOptions) throws {
        switch option {
            case .cancelAllOperation(let session):
                try ops.forEach { _ = try $0.cancelOperation() }
                switch session {
                    case .none:
                        break
//                        tasksOperationQueue.cancelAllOperations() // this line is unUseful
                    case .invalidateAndCancel:
                        tasksOperationQueue.cancelAllOperations()
                        urlSession.invalidateAndCancel()
                    case .flush(let handler):
                        urlSession.flush(completionHandler: handler)
                    case .reset(let handler):
                        urlSession.reset(completionHandler: handler)
                }
                
            case .cancelReadyOperationsAndWait:
                tasksOperationQueue.cancelAllOperations()
                urlSession.finishTasksAndInvalidate()
                
            case .cancelReadyOperation(let execpt):
                try ops
                    .filter {
                    !execpt.contains($0.identifier) &&
                    !$0._finished &&
                    !$0._executing }
                    .forEach { _ = try $0.cancelOperation() }
                
            case .cancelExecutingOperation(let execpt):
                try ops
                    .filter {
                    !execpt.contains($0.identifier) &&
                    $0._executing &&
                    !$0._finished }
                    .forEach { _ = try $0.cancelOperation() }
        }
    }
    
    /// Call this method if you dont want to use `Rx`extension, this will initialize `URLSesssion` property
    /// - Returns: self
    public func startSession() -> Self {
        urlSession = URLSession(configuration: config,
                                delegate: nil,
                                delegateQueue: delegateOperationQueue)
        return self
    }
    
    fileprivate func checkForSessionIsNotNil() throws {
        guard !urlSession.isNil else {
            throw SessionError.sessionIsNil(
                "call startSession to initialize session"
            )
        }
    }
    
    fileprivate func startmonitoring() {
        network.start(queue: .global(qos: .utility))
    }
    
    fileprivate func cehckForConnectivity() throws {
        if network.currentPath.status == .satisfied {
            return
        }
        throw SessionError.networkDisconnect
    }
    
    fileprivate func freeUnusedTasks() throws {
        try self.ops
            .enumerated()
            .filter { $0.element.taskState == .completed }
            .forEach {
                _ = try $0.element.completeOperation()
                self.ops.remove(at: $0.offset)
            }
        print(tasksOperationQueue.operationCount)
        print(ops.count)
    }
    
    public func changeSessionConfig(_ config: (URLSessionConfiguration) -> ()) -> Self {
        config(self.config)
        return self
    }
    
    public func changeSessionConfig(_ config: () -> (URLSessionConfiguration)) -> Self {
        self.config = config()
        return self
    }
    
    public func changeOperationQueueConfig(_ config: (OperationQueue) -> ()) -> Self {
        config(self.tasksOperationQueue)
        return self
    }
    
    internal func createTask<T>(_ builder:TaskBuilder<T>) throws -> T where T:TaskOperationControllerBaseProtocol {
        guard !urlSession.isNil else {
            throw SessionError.sessionIsNil(
                "call startSession to initialize session"
            )
        }
        guard network.currentPath.status == .satisfied else {
            throw SessionError.networkDisconnect
        }
        let compeletion = { [weak self] in
            guard let self = self else {
                return
            }
            do {
                try self.freeUnusedTasks()
            } catch  {
                print(error)
            }
            return
        }
        return ops <- try builder(urlSession,compeletion)
    }
}
