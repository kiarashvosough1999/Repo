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
                              options: OperationConfig = OperationConfig(),
                              completionHandler: @escaping SessionDataTaskDecodedResponse<U>)
    throws -> some DataTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                             EndPoint:EndPointHTTPType,
                                                             T.EndPoint == EndPoint,
                                                             U:Decodable {
        
        try createTask { session, completed -> DataTaskOperationController in
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
            return DataTaskOperationController(operationQueue: tasksOperationQueue,
                                               sessionTask: wrapper,
                                               operationConfig: options)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func dataTask<T>(with route: EndPoint,
                            requestBuilder: T,
                            options: OperationConfig = OperationConfig(),
                            completionHandler: @escaping SessionDataTaskResponse)
    throws -> some DataTaskOperationControllerProtocol where T: URLRequestBuilderProtocol,
                                                             EndPoint:EndPointHTTPType,
                                                             T.EndPoint == EndPoint {
        
        try createTask { session, completed -> DataTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DataTaskOperationController(operationQueue: tasksOperationQueue,
                                               sessionTask: wrapper,
                                               operationConfig: options)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func dataTask(with route: EndPoint,
                         and options: OperationConfig = OperationConfig(),
                         completionHandler: @escaping SessionDataTaskResponse)
    throws -> some DataTaskOperationControllerProtocol where EndPoint:EndPointHTTPType {
        try createTask { session, completed -> DataTaskOperationController in
            let wrapper = session.dataTask(with:  route.url, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DataTaskOperationController(operationQueue: tasksOperationQueue,
                                               sessionTask: wrapper,
                                               operationConfig: options)
        }
    }
    
    @available(iOS 13.0, *)
    @discardableResult
    public func dataTask(with request: URLRequest,
                         and options: OperationConfig = OperationConfig(),
                         completionHandler: @escaping SessionDataTaskResponse)
    throws -> some TaskOperationControllerProtocol {
        try createTask { session, completed -> DataTaskOperationController in
            let wrapper = self.urlSession.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DataTaskOperationController(operationQueue: tasksOperationQueue,
                                               sessionTask: wrapper,
                                               operationConfig: options)
        }
        
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask<T>(with route: EndPoint,
                                 requestBuilder: T,
                                 options: OperationConfig = OperationConfig(),
                                 completionHandler: @escaping SessionDataTaskResponse)
    throws -> DataTaskOperationController where T: URLRequestBuilderProtocol,
                                                EndPoint:EndPointHTTPType,
                                                T.EndPoint == EndPoint {
        
        try createTask { session, completed -> DataTaskOperationController in
            let request = try requestBuilder.buildRequest(from: route)
            let wrapper = session.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DataTaskOperationController(operationQueue: tasksOperationQueue,
                                               sessionTask: wrapper,
                                               operationConfig: options)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask(with route: EndPoint,
                              and options: OperationConfig = OperationConfig(),
                              completionHandler: @escaping SessionDataTaskResponse)
    throws -> DataTaskOperationController where EndPoint:EndPointHTTPType {
        try createTask { session, completed -> DataTaskOperationController in
            let wrapper = session.dataTask(with:  route.url, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DataTaskOperationController(operationQueue: tasksOperationQueue,
                                               sessionTask: wrapper,
                                               operationConfig: options)
        }
    }
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask(with request: URLRequest,
                              and options: OperationConfig = OperationConfig(),
                              completionHandler: @escaping SessionDataTaskResponse)
    throws -> DataTaskOperationController {
        try createTask { session, completed -> DataTaskOperationController in
            let wrapper = self.urlSession.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return DataTaskOperationController(operationQueue: tasksOperationQueue,
                                               sessionTask: wrapper,
                                               operationConfig: options)
        }
        
    }
    
    
    @available(iOS, introduced: 9.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask(with request: URLRequest,
                              and options: OperationConfig = OperationConfig(),
                              completionHandler: @escaping SessionDataTaskResponse) throws -> TaskOperationControllerBaseProtocol {
        try createTask { session, completed -> AnyTaskOperationController in
            let wrapper = session.dataTask(with:  request, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return AnyTaskOperationController(operationQueue: tasksOperationQueue,
                                              sessionTask: wrapper,
                                              operationConfig: options)
        }
        
    }
    
    @available(iOS, introduced: 10.0, deprecated: 13.0, message: "Use new method with opaque types")
    @discardableResult
    public func startDataTask(with route: EndPoint,
                              and options: OperationConfig = OperationConfig(),
                              completionHandler: @escaping SessionDataTaskResponse)
    throws -> TaskOperationControllerBaseProtocol where EndPoint:EndPointHTTPType {
        try createTask { session, completed -> AnyTaskOperationController in
            let wrapper = self.urlSession.dataTask(with:  route.url, completionHandler: { data, resp, error in
                completionHandler(data,resp,error)
                completed()
            })
            return AnyTaskOperationController(operationQueue: tasksOperationQueue,
                                              sessionTask: wrapper,
                                              operationConfig: options)
        }
    }
}
