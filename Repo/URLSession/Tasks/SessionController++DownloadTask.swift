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
                                operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> some DownloadTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                                 EndPoint:EndPointDownloadType,
                                                                 T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkDownloadTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.downloadTask(with:  request,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                          sessionTask: wrapper,
                                                          configuration: operationConfiguration)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func downloadTask(with route: EndPoint,
                             operationConfiguration: OperationConfiguration = OperationConfiguration(),
                             completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> some DownloadTaskOperationControllerProtocol where EndPoint:EndPointDownloadType {
        try createTask { session, completed -> NetworkDownloadTaskOperationController in
            let wrapper = session.downloadTask(with:  route.url,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                          sessionTask: wrapper,
                                                          configuration: operationConfiguration)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func downloadTask(on resumeData: Data,
                             with operationConfiguration: OperationConfiguration = OperationConfiguration(),
                             completionHandler: @escaping SessionDownloadTaskResponse) throws
    -> some DownloadTaskOperationControllerProtocol where EndPoint:EndPointDownloadType {
        try createTask { session, completed -> NetworkDownloadTaskOperationController in
            let wrapper = session.downloadTask(withResumeData: resumeData, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                          sessionTask: wrapper,
                                                          configuration: operationConfiguration)
        }
        
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func downloadTask(with request: URLRequest,
                             and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                             completionHandler: @escaping SessionDownloadTaskResponse) throws -> some NetworkTaskOperationControllable {
        try createTask { session, completed -> NetworkDownloadTaskOperationController in
            let wrapper = session.downloadTask(with: request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                          sessionTask: wrapper,
                                                          configuration: operationConfiguration)
        }
        
    }
    
    // MARK: - Old API
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask<T>(with route: EndPoint,
                                     requestBuilder: T,
                                     operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                     completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> NetworkDownloadTaskOperationController where T: URLRequestBuilderProtocol,
                                                           EndPoint:EndPointDownloadType,
                                                           T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkDownloadTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.downloadTask(with:  request,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                          sessionTask: wrapper,
                                                          configuration: operationConfiguration)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask(with route: EndPoint,
                                  operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                  completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> NetworkDownloadTaskOperationController where EndPoint:EndPointDownloadType{
        try createTask { session, completed -> NetworkDownloadTaskOperationController in
            let wrapper = session.downloadTask(with:  route.url,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                          sessionTask: wrapper,
                                                          configuration: operationConfiguration)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask(on resumeData: Data,
                                  with operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                  completionHandler: @escaping SessionDownloadTaskResponse) throws
    -> NetworkDownloadTaskOperationController where EndPoint:EndPointDownloadType{
        try createTask { session, completed -> NetworkDownloadTaskOperationController in
            let wrapper = session.downloadTask(withResumeData: resumeData, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                          sessionTask: wrapper,
                                                          configuration: operationConfiguration)
        }
        
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask(with request: URLRequest,
                                  and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                  completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> NetworkDownloadTaskOperationController {
        try createTask { session, completed -> NetworkDownloadTaskOperationController in
            let wrapper = session.downloadTask(with: request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDownloadTaskOperationController(operationQueue: tasksOperationQueue,
                                                          sessionTask: wrapper,
                                                          configuration: operationConfiguration)
        }
    }
    
    //MARK: - General API
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask<T>(with route: EndPoint,
                                     requestBuilder: T,
                                     operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                     completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> NetworkTaskOperationControllableBase where T: URLRequestBuilderProtocol,
                                                         EndPoint:EndPointDownloadType,
                                                         T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkAnyTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.downloadTask(with:  request,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkAnyTaskOperationController(operationQueue: tasksOperationQueue,
                                                     sessionTask: wrapper,
                                                     configuration: operationConfiguration)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask(with route: EndPoint,
                                  operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                  completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> NetworkTaskOperationControllableBase where EndPoint:EndPointDownloadType{
        try createTask { session, completed -> NetworkAnyTaskOperationController in
            let wrapper = session.downloadTask(with:  route.url,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkAnyTaskOperationController(operationQueue: tasksOperationQueue,
                                                     sessionTask: wrapper,
                                                     configuration: operationConfiguration)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask(on resumeData: Data,
                                  with operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                  completionHandler: @escaping SessionDownloadTaskResponse) throws
    -> NetworkTaskOperationControllableBase where EndPoint:EndPointDownloadType{
        try createTask { session, completed -> NetworkAnyTaskOperationController in
            let wrapper = session.downloadTask(withResumeData: resumeData, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkAnyTaskOperationController(operationQueue: tasksOperationQueue,
                                                     sessionTask: wrapper,
                                                     configuration: operationConfiguration)
        }
        
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDownloadTask(with request: URLRequest,
                                  and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                  completionHandler: @escaping SessionDownloadTaskResponse)
    throws -> NetworkTaskOperationControllableBase {
        try createTask { session, completed -> NetworkAnyTaskOperationController in
            let wrapper = session.downloadTask(with: request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkAnyTaskOperationController(operationQueue: tasksOperationQueue,
                                                     sessionTask: wrapper,
                                                     configuration: operationConfiguration)
        }
    }
}
