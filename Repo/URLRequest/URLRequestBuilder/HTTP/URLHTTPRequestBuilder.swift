//
//  URLHTTPRequestBuilder.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

final public class URLHTTPRequestBuilder<EndPoint>: URLHTTPRequestBuilderProtocol where EndPoint: EndPointHTTPType {
    
    public private(set) var encoder: ParameterEncoderProtocol?
    
    public private(set) var config: HTTPURLRequestConfiguration
    
    
    public init(config: HTTPURLRequestConfiguration = HTTPURLRequestConfiguration()) {
        self.config = config
    }
    
    @discardableResult
    public func changeURLRequestConfiguration(_ config: (inout HTTPURLRequestConfiguration) -> Void) throws -> Self {
        config(&self.config)
        return self
    }
    
    @discardableResult
    public func changeEncoderConfiguration(_ config: (inout ParameterEncodingConfiguration) -> Void) throws -> Self {
        guard var configuration = encoder?.configuration else {
            throw URLRequestBuilderError.encoderIsNil
        }
        config(&configuration)
        return self
    }
    
    @discardableResult
    public func changeEncoder(_ config: () -> ParameterEncoderProtocol) throws -> Self {
        self.encoder = config()
        return self
    }
    
    
    public func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path),
                                 method: route.httpMethod(),
                                 cachePolicy: config.cachePolicy,
                                 timeoutInterval: config.timeoutInterval)
        if config.setDeafultEncoder {
            encoder = ParameterEncoder(urlRequest: &request)
        }
        guard var encoder = encoder else {
            throw URLRequestBuilderError.encoderIsNil
        }
        if !config.setDeafultEncoder { encoder.urlRequest = request }
        do {
            try autoreleasepool {
                switch route.task {
                    case .request:
                        try encoder.encodeJustHeader()
                    case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
                        
                        try encoder.encode(bodyParameters: bodyParameters,
                                           urlParameters: urlParameters,
                                           parameterEncoding: bodyEncoding)
                        
                    case .requestParametersAndHeaders(let bodyParameters,
                                                      let bodyEncoding,
                                                      let urlParameters,
                                                      let additionalHeaders):
                        
                        try encoder.addAdditionalHeaders(additionalHeaders)
                        try encoder.encode(bodyParameters: bodyParameters,
                                           urlParameters: urlParameters,
                                           parameterEncoding: bodyEncoding)
                }
            }
            return encoder.urlRequest
        }
        catch {
            throw error
        }
    }
}

extension URLRequest {
    
    init(url: URL,
         method: String,
         cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy,
         timeoutInterval: TimeInterval = 60.0) {
        self.init(url: url, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
        self.httpMethod = method
    }
}
