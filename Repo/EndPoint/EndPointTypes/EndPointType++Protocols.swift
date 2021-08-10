//
//  EndPointType++Protocols.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

public typealias HTTPHeaders = [String:String]
public typealias RxNetworkRouterCompletion = (response: HTTPURLResponse, data: Data)
public typealias NetworkRouterCompletion = (_ data: Data?,_ response: URLResponse?,_ error: Error?) -> ()
public typealias Parameters = [String:Any]

public protocol EndPointType: Hashable {
    
    /// The base path of `Current` EndPoint
    var baseURL: URL { get }
    
    /// Indicating the version of `Current` EndPoint which will be append to` baseURL`
    var apiVersion: APIVersion { get }
    
    /// Appending path to  result of `baseURL + apiVesrion` for specific request
    var path: String { get }
    
    /// Provided `HTTP Mehod` for requested Task
    var httpMethod: Method { get }
    
    /// Provided full path to a server endpoint which won't be affected by configuration of above
    /// The request will be using just this URL to start its task
    var url:URL { get }
}

/// Every `EndPoint` which want to operate with `HTTP Tasks` should implement
public protocol EndPointHTTPType: EndPointType {
    
    /// Each case of endpoint should have a `HTTPTask`
    /// which will be used on  request builder class which conform to `EndPointHTTPType` or its child protocol
    var task: HTTPTask { get }
    
    /// Provided `Header` for each request
    /// HTTPHeaders is a `Typalias` for `Dictionary<String,String>` type
    var headers: HTTPHeaders? { get }
}

/// Every `EndPoint` which want to operate with `Download Tasks` should implement
public protocol EndPointDownloadType: EndPointType {
}

/// Every `EndPoint` which want to operate with `Upload Tasks` should implement
public protocol EndPointUploadType: EndPointType {
    
    /// Provided file `URL` to upload for requested Task
    var fileUrl: URL { get }
}

public protocol EndPointSocketType: EndPointType {
    
    /// provided protocols to negotiate a preferred protocol with the server.
    /// Note The protocol doesn’t affect the WebSocket framing.
    /// More details on the protocol are available in RFC 6455, The WebSocket Protocol.
    var protocols:[String] { get }
}

public protocol EndPointStreamType: EndPointType {
    
    /// A TCP Address model which indicate what address and port, the stream should be connected to.
    var tcpAddress:TCPAddress { get }
}
