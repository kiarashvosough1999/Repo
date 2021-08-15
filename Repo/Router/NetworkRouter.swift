//
//  NetworkRouter.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

protocol NetworkRouter: AnyObject {
    
    associatedtype EndPoint: EndPointType
    
    var sessionController:SessionController<EndPoint> { get }
    
    func request(_ route: EndPoint,
                 completion: @escaping NetworkRouterCompletion)
}


@propertyWrapper
struct OpenSession<EndPoint:Hashable> {
    
    var wrappedValue:SessionController<EndPoint>
    
    var projectedValue: SessionController<EndPoint> {
        wrappedValue
    }
    
    init(wrappedValue: SessionController<EndPoint>,_ maxConcurrentOperationCount:Int = 1) {
        self.wrappedValue = wrappedValue.startSession()
        self.projectedValue
            .tasksOperationQueue
            .maxConcurrentOperationCount = maxConcurrentOperationCount
    }
}

@propertyWrapper
struct WebSocketSession<EndPoint:Hashable> {
    
    var wrappedValue:SessionController<EndPoint>
    var identifier:OperationIdentifier
    
    var projectedValue: NetworkWebSocketTaskOperationController {
        guard let socket = wrappedValue.opss[identifier] as? NetworkWebSocketTaskOperationController else {
            fatalError("There is no socket with this \(identifier) identifier")
        }
        return socket
    }
    
    init(wrappedValue: SessionController<EndPoint>, identifier: OperationIdentifier, _ maxConcurrentOperationCount: Int = 1) {
        self.wrappedValue = wrappedValue.startSession()
        self.identifier = identifier
        self.wrappedValue
            .tasksOperationQueue
            .maxConcurrentOperationCount = maxConcurrentOperationCount
    }
}
