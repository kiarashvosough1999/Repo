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
    internal private(set) var config:URLSessionConfiguration
    internal private(set) var delegateOperationQueue: OperationQueue?
    internal private(set) var tasksOperationQueue: OperationQueue
    internal private(set) var opss:[OperationIdentifier:TaskOperationControllerBaseProtocol] = [:]
    private let network: NWPathMonitor
    lazy private var dispachLabel = "Session\(ObjectIdentifier(self))"
    
    public init(config:URLSessionConfiguration = URLSessionConfiguration.default,
                delegateOperationQueue: OperationQueue = OperationQueue(),
                underlyingQueue:DispatchQueue? = nil,
                tasksOperationQueue: OperationQueue = OperationQueue()) {
        self.delegateOperationQueue = delegateOperationQueue
        self.tasksOperationQueue = tasksOperationQueue
        self.config = config
        self.network = NWPathMonitor()
        super.init()
        self.tasksOperationQueue.underlyingQueue = underlyingQueue.or(DispatchQueue(label: dispachLabel))
        configureSession()
    }
    
    deinit {
        self.tasksOperationQueue.underlyingQueue.toggleNil()
        network.cancel()
        opss.removeAll()
        tasksOperationQueue.cancelAllOperations()
        urlSession.invalidateAndCancel()
    }
    
    fileprivate func configureSession() {
        startmonitoring()
    }
    
    #warning("should be checked")
    public func executeCancel(with option: OperationCancelOptions) throws {
        switch option {
            case .cancelAllOperation(let session):
                try opss.forEach { _ = try $0.value.cancelOperation() }
                opss.removeAll()
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
                opss.remove { $0.value.state == .canceled }
                urlSession.finishTasksAndInvalidate()
                
            case .cancelReadyOperation(let execpt):
                try opss
                    .remove({
                        !execpt.contains($0.value.identifier) &&
                        $0.value.state == .ready
                    }, execute: {
                        _ = try $0.value.cancelOperation()
                    })
                
            case .cancelExecutingOperation(let execpt):
                try opss
                    .remove({
                        !execpt.contains($0.value.identifier) &&
                        $0.value.state == .executing
                    }, execute: {
                        _ = try $0.value.cancelOperation()
                    })
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
        self.opss
            .remove({
                $0.value.taskState == .completed ||
                $0.value.taskState == .canceling
            }, execute: {
                do {
                   try $0.value.completeOperation()
                }catch {
                    print(error)
                }
            })
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
        return opss <- try builder(urlSession, compeletion)
    }
}
