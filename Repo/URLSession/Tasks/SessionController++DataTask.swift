//
//  SessionController++DataTask.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

extension SessionController {
    
    @available(iOS 13.0, *)
    @discardableResult
    public func dataTask<T,U>(with route: EndPoint,
                              requestBuilder: T,
                              operationConfiguration: OperationConfiguration = OperationConfiguration(),
                              completionHandler: @escaping SessionDataTaskDecodedResponse<U>)
    throws -> some DataTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                             EndPoint:EndPointHTTPType,
                                                             T.EndPoint == EndPoint,
                                                             U:Decodable {
        
        try createTask { session, completed -> NetworkDataTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.dataTask(with:  request, completionHandler: { data, resp, error in
                completed()
                #warning("should encapsulate decoding")
                if let error = error as NSError? {
                    return completionHandler(.failure(.networkError(error)),resp)
                }
                
                guard let data = data else {
                    return completionHandler(.failure(.nilData), resp)
                }
                do {
                    let res = try JSONDecoder().decode(U.self, from: data)
                    completionHandler(.success(res),resp)
                }
                catch let error as DecodingError {
                    completionHandler(.failure(.decodingError(error)), resp)
                }
                catch {
                    completionHandler(.failure(.error), resp)
                }
            })
            return NetworkDataTaskOperationController(operationQueue: tasksOperationQueue,
                                                      sessionTask: wrapper,
                                                      configuration: operationConfiguration)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func dataTask<T>(with route: EndPoint,
                            requestBuilder: T,
                            operationConfiguration: OperationConfiguration = OperationConfiguration(),
                            completionHandler: @escaping SessionDataTaskResponse)
    throws -> some DataTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                             EndPoint:EndPointHTTPType,
                                                             T.EndPoint == EndPoint {
        
        try createTask { session, completed -> NetworkDataTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDataTaskOperationController(operationQueue: tasksOperationQueue,
                                                      sessionTask: wrapper,
                                                      configuration: operationConfiguration)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func dataTask(with route: EndPoint,
                         and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                         completionHandler: @escaping SessionDataTaskResponse)
    throws -> some DataTaskOperationControllerProtocol where EndPoint:EndPointHTTPType {
        try createTask { session, completed -> NetworkDataTaskOperationController in
            let wrapper = session.dataTask(with:  route.url, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDataTaskOperationController(operationQueue: tasksOperationQueue,
                                                      sessionTask: wrapper,
                                                      configuration: operationConfiguration)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func dataTask(with request: URLRequest,
                         and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                         completionHandler: @escaping SessionDataTaskResponse)
    throws -> some NetworkTaskOperationControllable {
        try createTask { session, completed -> NetworkDataTaskOperationController in
            let wrapper = self.urlSession.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDataTaskOperationController(operationQueue: tasksOperationQueue,
                                                      sessionTask: wrapper,
                                                      configuration: operationConfiguration)
        }
        
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask<T>(with route: EndPoint,
                                 requestBuilder: T,
                                 operationConfiguration: OperationConfiguration = OperationConfiguration(),
                                 completionHandler: @escaping SessionDataTaskResponse)
    throws -> NetworkDataTaskOperationController where T: URLRequestBuilderProtocol,
                                                       EndPoint:EndPointHTTPType,
                                                       T.EndPoint == EndPoint {
        
        try createTask { session, completed -> NetworkDataTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDataTaskOperationController(operationQueue: tasksOperationQueue,
                                                      sessionTask: wrapper,
                                                      configuration: operationConfiguration)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask(with route: EndPoint,
                              and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                              completionHandler: @escaping SessionDataTaskResponse)
    throws -> NetworkDataTaskOperationController where EndPoint:EndPointHTTPType {
        try createTask { session, completed -> NetworkDataTaskOperationController in
            let wrapper = session.dataTask(with:  route.url, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDataTaskOperationController(operationQueue: tasksOperationQueue,
                                                      sessionTask: wrapper,
                                                      configuration: operationConfiguration)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask(with request: URLRequest,
                              and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                              completionHandler: @escaping SessionDataTaskResponse)
    throws -> NetworkDataTaskOperationController {
        try createTask { session, completed -> NetworkDataTaskOperationController in
            let wrapper = self.urlSession.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkDataTaskOperationController(operationQueue: tasksOperationQueue,
                                                      sessionTask: wrapper,
                                                      configuration: operationConfiguration)
        }
        
    }
    
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask(with request: URLRequest,
                              and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                              completionHandler: @escaping SessionDataTaskResponse) throws -> NetworkTaskOperationControllableBase {
        try createTask { session, completed -> NetworkAnyTaskOperationController in
            let wrapper = session.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkAnyTaskOperationController(operationQueue: tasksOperationQueue,
                                                     sessionTask: wrapper,
                                                     configuration: operationConfiguration)
        }
        
    }
    
    @available(iOS, introduced: 10.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask(with route: EndPoint,
                              and operationConfiguration: OperationConfiguration = OperationConfiguration(),
                              completionHandler: @escaping SessionDataTaskResponse)
    throws -> NetworkTaskOperationControllableBase where EndPoint:EndPointHTTPType {
        try createTask { session, completed -> NetworkAnyTaskOperationController in
            let wrapper = self.urlSession.dataTask(with:  route.url, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return NetworkAnyTaskOperationController(operationQueue: tasksOperationQueue,
                                                     sessionTask: wrapper,
                                                     configuration: operationConfiguration)
        }
    }
}
