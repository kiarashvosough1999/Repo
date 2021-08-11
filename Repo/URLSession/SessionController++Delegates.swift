//
//  SessionController++Delegates.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/8/1400 AP.
//

import Foundation

//typealias SessionDelegate = URLSessionDelegate &
//    URLSessionTaskDelegate &
//    URLSessionDataDelegate &
//    URLSessionWebSocketDelegate &
//    URLSessionStreamDelegate &
//    URLSessionDownloadDelegate

extension SessionController {
    
    public var delegate:URLSessionDelegate? {
        set {
            delegateSetter(delegate: newValue)
        }
        get {
            urlSession.delegate
        }
    }
    
    public var taskDelegate:URLSessionTaskDelegate? {
        set {
            delegateSetter(delegate: newValue)
        }
        get {
            urlSession.delegate as? URLSessionTaskDelegate
        }
    }
    //....... should be implemnted for rx and so on
    
    internal func delegateSetter<T>(delegate:T?) where T: URLSessionDelegate {
        urlSession = URLSession(configuration: config,
                                delegate: delegate,
                                delegateQueue: delegateOperationQueue)
    }
}
