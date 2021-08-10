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
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: Method { get }
    var url:URL { get }
}

public protocol EndPointHTTPType: EndPointType {
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}

public protocol EndPointDownloadType: EndPointType {
}

public protocol EndPointUploadType: EndPointType {
    var fileUrl: URL { get }
}

public protocol EndPointSocketType: EndPointType {
    var protocols:[String] { get }
}

public protocol EndPointStreamType: EndPointType {
    var tcpAddress:TCPAddress { get }
}
