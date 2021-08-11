//
//  SessionController++DownloadTask.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

extension SessionController {
    
    @available(iOS 13.0, *)
    @discardableResult
    public func downloadTask<T>(with route: EndPoint,
                                     requestBuilder: T,
                                     options: OperationConfig = OperationConfig(),
                                     completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> some DownloadTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                                 EndPoint:EndPointDownloadType,
                                                                 T.EndPoint == EndPoint {
        try createTask { session, completed -> DownloadTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.downloadTask(with:  request,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                   sessionTask: wrapper,
                                                   operationConfig: options)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    @usableFromInline
    func downloadTask(with route: EndPoint,
                           options: OperationConfig = OperationConfig(),
                           completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> some DownloadTaskOperationControllerProtocol where EndPoint:EndPointDownloadType {
        try createTask { session, completed -> DownloadTaskOperationController in
            let wrapper = session.downloadTask(with:  route.url,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                   sessionTask: wrapper,
                                                   operationConfig: options)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    @usableFromInline
    func downloadTask(on resumeData: Data,
                           with options: OperationConfig = OperationConfig(),
                           completionHandler: @escaping SessionDownloadTaskResponse) throws
    -> some DownloadTaskOperationControllerProtocol where EndPoint:EndPointDownloadType {
        try createTask { session, completed -> DownloadTaskOperationController in
            let wrapper = session.downloadTask(withResumeData: resumeData, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                   sessionTask: wrapper,
                                                   operationConfig: options)
        }
        
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func downloadTask(with request: URLRequest,
                                  and options: OperationConfig = OperationConfig(),
                                  completionHandler: @escaping SessionDownloadTaskResponse) throws -> some TaskOperationControllerProtocol {
        try createTask { session, completed -> DownloadTaskOperationController in
            let wrapper = session.downloadTask(with: request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                   sessionTask: wrapper,
                                                   operationConfig: options)
        }
        
    }
    
    // MARK: - Old API
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask<T>(with route: EndPoint,
                                     requestBuilder: T,
                                     options: OperationConfig = OperationConfig(),
                                     completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> DownloadTaskOperationController where T: URLRequestBuilderProtocol,
                                                    EndPoint:EndPointDownloadType,
                                                    T.EndPoint == EndPoint {
        try createTask { session, completed -> DownloadTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.downloadTask(with:  request,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                   sessionTask: wrapper,
                                                   operationConfig: options)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    @usableFromInline
    func startDownloadTask(with route: EndPoint,
                           options: OperationConfig = OperationConfig(),
                           completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> DownloadTaskOperationController where EndPoint:EndPointDownloadType{
        try createTask { session, completed -> DownloadTaskOperationController in
            let wrapper = session.downloadTask(with:  route.url,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                   sessionTask: wrapper,
                                                   operationConfig: options)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    @usableFromInline
    func startDownloadTask(on resumeData: Data,
                           with options: OperationConfig = OperationConfig(),
                           completionHandler: @escaping SessionDownloadTaskResponse) throws
    -> DownloadTaskOperationController where EndPoint:EndPointDownloadType{
        try createTask { session, completed -> DownloadTaskOperationController in
            let wrapper = session.downloadTask(withResumeData: resumeData, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                   sessionTask: wrapper,
                                                   operationConfig: options)
        }
        
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask(with request: URLRequest,
                                  and options: OperationConfig = OperationConfig(),
                                  completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> DownloadTaskOperationController {
        try createTask { session, completed -> DownloadTaskOperationController in
            let wrapper = session.downloadTask(with: request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                   sessionTask: wrapper,
                                                   operationConfig: options)
        }
    }
    
    //MARK: - General API
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask<T>(with route: EndPoint,
                                     requestBuilder: T,
                                     options: OperationConfig = OperationConfig(),
                                     completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> TaskOperationControllerBaseProtocol where T: URLRequestBuilderProtocol,
                                                        EndPoint:EndPointDownloadType,
                                                        T.EndPoint == EndPoint {
        try createTask { session, completed -> AnyTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.downloadTask(with:  request,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return AnyTaskOperationController(operationQueue: tasksOperationQueue,
                                              sessionTask: wrapper,
                                              operationConfig: options)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    @usableFromInline
    func startDownloadTask(with route: EndPoint,
                           options: OperationConfig = OperationConfig(),
                           completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> TaskOperationControllerBaseProtocol where EndPoint:EndPointDownloadType{
        try createTask { session, completed -> AnyTaskOperationController in
            let wrapper = session.downloadTask(with:  route.url,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return AnyTaskOperationController(operationQueue: tasksOperationQueue,
                                              sessionTask: wrapper,
                                              operationConfig: options)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    @usableFromInline
    func startDownloadTask(on resumeData: Data,
                           with options: OperationConfig = OperationConfig(),
                           completionHandler: @escaping SessionDownloadTaskResponse) throws
    -> TaskOperationControllerBaseProtocol where EndPoint:EndPointDownloadType{
        try createTask { session, completed -> AnyTaskOperationController in
            let wrapper = session.downloadTask(withResumeData: resumeData, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return AnyTaskOperationController(operationQueue: tasksOperationQueue,
                                              sessionTask: wrapper,
                                              operationConfig: options)
        }
        
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask(with request: URLRequest,
                                  and options: OperationConfig = OperationConfig(),
                                  completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> TaskOperationControllerBaseProtocol {
        try createTask { session, completed -> AnyTaskOperationController in
            let wrapper = session.downloadTask(with: request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return AnyTaskOperationController(operationQueue: tasksOperationQueue,
                                              sessionTask: wrapper,
                                              operationConfig: options)
        }
    }
}
