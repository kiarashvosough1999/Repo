//
//  HTTPTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/10/1400 AP.
//

import Foundation

final public class NetworkDataTaskOperationController: NetworkOperationController<URLSessionDataTask,DataTaskConfig> {
    
    public var HTTPURLResponse: HTTPURLResponse? {
        response as? HTTPURLResponse
    }
    
}

extension NetworkDataTaskOperationController: DataTaskOperationControllerProtocol {}
