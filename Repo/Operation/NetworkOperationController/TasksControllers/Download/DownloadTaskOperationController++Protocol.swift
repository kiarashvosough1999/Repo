//
//  DownloadTaskOperationControllerProtocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation

public protocol DownloadTaskOperationControllerProtocol: NetworkTaskOperationControllable where SessionTask == URLSessionDownloadTask,
                                                                                               TaskConfiguration: DownloadTaskConfigurationProtocol {
    func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void) -> Self
}
public protocol DownloadTaskConfigurationProtocol: URLSessionAnyTaskConfigurationProtocol {
    
}
