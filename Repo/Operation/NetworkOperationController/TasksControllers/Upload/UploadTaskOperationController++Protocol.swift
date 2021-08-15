//
//  UploadTaskOperationController++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation

public protocol UploadTaskOperationControllerProtocol: NetworkTaskOperationControllable
where SessionTask == URLSessionUploadTask,
      TaskConfiguration:UploadTaskConfigurationProtocol
{
    
}

public protocol UploadTaskConfigurationProtocol: URLSessionAnyTaskConfigurationProtocol {
    
}
