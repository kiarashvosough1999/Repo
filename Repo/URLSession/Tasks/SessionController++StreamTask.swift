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
    public func startStreamTask(with route: EndPoint,
                         options: OperationConfig = OperationConfig()) throws
    -> some StreamTaskOperationControllerProtocol where EndPoint: EndPointStreamType {
        try createTask({ session, _ -> StreamTaskOperationController in
            let task = session.streamTask(withHostName: route.tcpAddress.hostName,
                                             port: route.tcpAddress.port)
            return StreamTaskOperationController(operationQueue: tasksOperationQueue,
                                                 sessionTask: task,
                                                 operationConfig: options)
        })
    }
}
