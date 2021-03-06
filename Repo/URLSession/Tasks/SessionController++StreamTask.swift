//
//  SessionController++StreamTask.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

extension SessionController {
    
    #warning("not ready to use")
    
    @available(iOS 13.0, *)
    @discardableResult
    public func streamTask(with route: EndPoint,
                           operationConfiguration: OperationConfiguration = OperationConfiguration()) throws
    -> some StreamTaskOperationControllerProtocol where EndPoint: EndPointStreamType {
        try createTask({ session, _ -> NetworkStreamTaskOperationController in
            let task = session.streamTask(withHostName: route.tcpAddress.hostName,
                                          port: route.tcpAddress.port)
            return NetworkStreamTaskOperationController(operationQueue: tasksOperationQueue,
                                                        sessionTask: task,
                                                        configuration: operationConfiguration)
        })
    }
}
