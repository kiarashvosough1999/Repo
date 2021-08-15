//
//  StreamTaskOperationController++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation

public protocol StreamTaskOperationControllerProtocol: NetworkTaskOperationControllable where SessionTask == URLSessionStreamTask,
                                                                                             TaskConfiguration: StreamTaskConfiguration{
    
    func readData(ofMinLength minBytes: Int,
                  maxLength maxBytes: Int,
                  timeout: TimeInterval,
                  completionHandler: @escaping (Data?, Bool, Error?) -> Void) -> Self
    
    
    func write(_ data: Data,
               timeout: TimeInterval,
               completionHandler: @escaping (Error?) -> Void) -> Self
    
    
    func captureStreams() -> Self
    
    
    func closeWrite() -> Self
    
    
    func closeRead() -> Self
    
    
    func startSecureConnection() -> Self
    
    
    @available(iOS, introduced: 7.0, deprecated: 13.0, message: "TLS cannot be disabled once it is enabled")
    func stopSecureConnection() -> Self
}

public protocol StreamTaskConfiguration: URLSessionAnyTaskConfigurationProtocol { }
