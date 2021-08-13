//
//  StreamTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

public final class StreamTaskOperationController: OperationController<URLSessionStreamTask,StreamTaskConfig> {}

extension StreamTaskOperationController: StreamTaskOperationControllerProtocol {
    
    @discardableResult
    public func readData(ofMinLength minBytes: Int,
                  maxLength maxBytes: Int,
                  timeout: TimeInterval,
                  completionHandler: @escaping (Data?, Bool, Error?) -> Void)  -> Self {
        task?.readData(ofMinLength: minBytes,
                              maxLength: minBytes,
                              timeout: timeout,
                              completionHandler: completionHandler)
        return self
    }
    
    @discardableResult
    public func write(_ data: Data, timeout: TimeInterval, completionHandler: @escaping (Error?) -> Void)  -> Self {
        task?.write(data, timeout: timeout, completionHandler: completionHandler)
        return self
    }
    
    @discardableResult
    public func captureStreams()  -> Self {
        task?.captureStreams()
        return self
    }
    
    @discardableResult
    public func closeWrite()  -> Self {
        task?.closeWrite()
        return self
    }
    
    @discardableResult
    public func closeRead() -> Self {
        task?.closeRead()
        return self
    }
    
    @discardableResult
    public func startSecureConnection() -> Self {
        task?.startSecureConnection()
        return self
    }
    
    @available(iOS, introduced: 7.0, deprecated: 13.0, message: "TLS cannot be disabled once it is enabled")
    @discardableResult
    public func stopSecureConnection() -> Self {
        task?.stopSecureConnection()
        return self
    }
}
