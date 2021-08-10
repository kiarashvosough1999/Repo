//
//  URLRequestBuilder++URLRequestBuilderProtocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public protocol URLRequestBuilderProtocol: AnyObject {
    
    associatedtype EndPoint: EndPointType
    associatedtype URLRequestConfiguration: URLRequestConfigurationProtocol
    
    var encoder: ParameterEncoderProtocol? { get }
    var config: URLRequestConfiguration { get }
    
    func buildRequest(from route: EndPoint) throws -> URLRequest
    
    func changeURLRequestConfiguration(_ config: (inout URLRequestConfiguration) -> Void) throws -> Self
    func changeEncoderConfiguration(_ config: (inout ParameterEncodingConfiguration) -> Void) throws -> Self
    func changeEncoder(_ config: () -> ParameterEncoderProtocol) throws -> Self
}

enum URLRequestBuilderError: Error {
    case encoderIsNil
}
