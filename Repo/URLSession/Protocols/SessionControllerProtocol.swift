//
//  SessionControllerProtocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

public protocol SessionControllerProtocol: AnyObject {
    
    typealias ConfigurationCallBack<T> = (T) -> ()
    typealias ConfigurationSetter<T> = () -> (T)
    
    typealias SessionDataTaskDecodedResponse<T:Decodable> = (Result<T,ResponseDecoderError>,URLResponse?) -> Void
    
    typealias SessionDataTaskResponse = (Data?, URLResponse?, Error?) -> Void
    typealias SessionDownloadTaskResponse = (URL?, URLResponse?, Error?) -> Void
    typealias SessionUploadTaskResponse = (Data?, URLResponse?, Error?) -> Void
    typealias OnCompletion = () -> Void
    
    associatedtype EndPoint:Hashable
    
    var delegate:URLSessionDelegate? { get set }
    var taskDelegate:URLSessionTaskDelegate? { get set }
    
    func changeSessionConfig(_ config:ConfigurationCallBack<URLSessionConfiguration>) -> Self
    func changeSessionConfig(_ config:ConfigurationSetter<URLSessionConfiguration>) -> Self
}

public enum ResponseDecoderError:Error {
    case nilData
    case networkError(NSError)
    case decodingError(DecodingError)
    case error
}
