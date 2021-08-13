//
//  HTTPTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/10/1400 AP.
//

import Foundation

final public class DataTaskOperationController: OperationController<URLSessionDataTask,DataTaskConfig> {
    
    public var HTTPURLResponse: HTTPURLResponse? {
        response as? HTTPURLResponse
    }
    
}

extension DataTaskOperationController: DataTaskOperationControllerProtocol {}
