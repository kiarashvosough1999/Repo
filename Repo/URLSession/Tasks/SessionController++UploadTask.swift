//
//  SessionController++UploadTask.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

extension SessionController {
    
    @available(iOS 13.0, *)
    @discardableResult
    public func uploadTask<T>(on route: EndPoint,
                              with data:Data,
                              requestBuilder: T,
                              operationConfiguration: OperationConfiguration = OperationConfiguration(),
                              completionHandler: @escaping SessionUploadTaskResponse) throws
    -> some UploadTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                        EndPoint: EndPointUploadType,
                                                        T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkUploadTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.uploadTask(with:  request,
                                             from: data ,
                                             completionHandler: { data, resp, error in
                                                completionHandler(data,resp,error)
                                                completed()
                                             })
            return NetworkUploadTaskOperationController(operationQueue: tasksOperationQueue,
                                                        sessionTask: wrapper,
                                                        configuration: operationConfiguration)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func uploadTask<T>(on urlRoute: EndPoint,
                              requestBuilder: T,
                              operationConfiguration: OperationConfiguration = OperationConfiguration(),
                              completionHandler: @escaping SessionUploadTaskResponse) throws
    -> some UploadTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                        EndPoint: EndPointUploadType,
                                                        T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkUploadTaskOperationController in
            let request = try requestBuilder.buildRequest(from: urlRoute)
            let wrapper = session.uploadTask(with:  request, fromFile: urlRoute.fileUrl ,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkUploadTaskOperationController(operationQueue: tasksOperationQueue,
                                                        sessionTask: wrapper,
                                                        configuration: operationConfiguration)
        }
    }
    
    //MARK: - Old API
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startUploadTask<T>(on route: EndPoint,
                                   with data:Data,
                                   requestBuilder: T,
                                   operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                   completionHandler: @escaping SessionUploadTaskResponse) throws
    -> NetworkUploadTaskOperationController where T: URLRequestBuilderProtocol,
                                                  EndPoint: EndPointUploadType,
                                                  T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkUploadTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.uploadTask(with:  request,
                                             from: data ,
                                             completionHandler: { data, resp, error in
                                                completionHandler(data,resp,error)
                                                completed()
                                             })
            return NetworkUploadTaskOperationController(operationQueue: tasksOperationQueue,
                                                        sessionTask: wrapper,
                                                        configuration: operationConfiguration)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startUploadTask<T>(on urlRoute: EndPoint,
                                   requestBuilder: T,
                                   operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                   completionHandler: @escaping SessionUploadTaskResponse) throws
    -> NetworkUploadTaskOperationController where T: URLRequestBuilderProtocol,
                                                  EndPoint: EndPointUploadType,
                                                  T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkUploadTaskOperationController in
            let request = try requestBuilder.buildRequest(from: urlRoute)
            let wrapper = session.uploadTask(with:  request, fromFile: urlRoute.fileUrl ,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkUploadTaskOperationController(operationQueue: tasksOperationQueue,
                                                        sessionTask: wrapper,
                                                        configuration: operationConfiguration)
        }
    }
    
    //MARK: - General API
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startUploadTask<T>(on route: EndPoint,
                                   with data:Data,
                                   requestBuilder: T,
                                   operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                   completionHandler: @escaping SessionUploadTaskResponse) throws
    -> NetworkTaskOperationControllableBase where T: URLRequestBuilderProtocol,
                                                  EndPoint: EndPointUploadType,
                                                  T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkAnyTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.uploadTask(with:  request,
                                             from: data ,
                                             completionHandler: { data, resp, error in
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
    public func startUploadTask<T>(on urlRoute: EndPoint,
                                   requestBuilder: T,
                                   operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                   completionHandler: @escaping SessionUploadTaskResponse) throws
    -> NetworkTaskOperationControllableBase where T: URLRequestBuilderProtocol,
                                                  EndPoint: EndPointUploadType,
                                                  T.EndPoint == EndPoint {
        try createTask { session, completed -> NetworkAnyTaskOperationController in
            let request = try requestBuilder.buildRequest(from: urlRoute)
            let wrapper = session.uploadTask(with:  request, fromFile: urlRoute.fileUrl ,completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkAnyTaskOperationController(operationQueue: tasksOperationQueue,
                                                     sessionTask: wrapper,
                                                     configuration: operationConfiguration)
        }
    }
    
    
    #warning("should be updated")
    //    @usableFromInline
    //    func startUploadTask<T>(using streamedRoute: EndPoint,
    //                            requestBuilder: T,
    //                            options: OperationConfig = OperationConfig()) throws
    //    -> some UploadTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
    //                                                        EndPoint: EndPointUploadType,
    //                                                        T.EndPoint == EndPoint {
    //        #warning("need urlSession(_:task:needNewBodyStream:)")
    //        let task = try urlSession.uploadTask(withStreamedRequest: requestBuilder.buildRequest(from: streamedRoute))
    //        return ops <- UploadTaskOperationController(operationQueue: tasksOperationQueue,
    //                                                    sessionTask: task,
    //                                                    operationConfig: options)
    //    }
}
