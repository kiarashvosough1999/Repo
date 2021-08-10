//
//  ParameterEncoder.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/6/1400 AP.
//

import Foundation

public final class ParameterEncoder: ParameterEncoderProtocol {
    
    public var configuration: ParameterEncodingConfiguration

    public var urlRequest:URLRequest
    
    public init(urlRequest: inout URLRequest,
                configuration: ParameterEncodingConfiguration = ParameterEncodingConfiguration()) {
        self.configuration = configuration
        self.urlRequest = urlRequest
    }
    
    
    public func encode(bodyParameters: Parameters?,
                       urlParameters: Parameters?,
                       parameterEncoding:ParameterEncodingType) throws {
        do {
            switch parameterEncoding {
            case .urlEncoding:
                guard let urlParameters = urlParameters else {
                    throw ParameterEncoderError.urlParametersNil
                }
                try self.URLParameterEncoder(urlParameters: urlParameters)
                
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else {
                    throw ParameterEncoderError.bodyParametersNil
                }
                try self.JSONParameterEncoder(bodyParameters: bodyParameters)
            case .urlAndJsonEncoding:
                guard let bodyParameters = bodyParameters else {
                    throw ParameterEncoderError.bodyParametersNil
                }
                guard let urlParameters = urlParameters else {
                    throw ParameterEncoderError.urlParametersNil
                }
                try self.JSONParameterEncoder(bodyParameters: bodyParameters)
                try self.URLParameterEncoder(urlParameters: urlParameters)
            }
        }catch {
            throw error
        }
    }
    
    public func encodeJustHeader() throws {
        do {
            if configuration.addDeafultHeader {
                try self.addAdditionalHeaders(configuration.deafultHeader)
            }else {
                self.urlRequest.setValue("application/json",
                                         forHTTPHeaderField: "Content-Type")
            }
        } catch  {
            throw error
        }
    }
    
    public func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?) throws {
        guard let headers = additionalHeaders else { throw ParameterEncoderError.headerParametersNil }
        for (key, value) in headers {
            urlRequest.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    public func URLParameterEncoder(urlParameters: Parameters?) throws {
        guard let url = urlRequest.url else { throw ParameterEncoderError.missingURL }
        guard let urlParameters = urlParameters,
              !urlParameters.isEmpty else { throw ParameterEncoderError.urlParametersNil }
        
        if var urlComponents = URLComponents(url: url,
                                             resolvingAgainstBaseURL: false) {
//            try configuration.urlComponentsConfigurator?(&urlComponents)
            urlComponents.queryItems = [URLQueryItem]()
            for (key,value) in urlParameters {
                let queryItem = URLQueryItem(name: key,
                                             value: "\(value)"
                                                .addingPercentEncoding(withAllowedCharacters: configuration.allowedCharachter))
                urlComponents.queryItems?.append(queryItem)
            }
            if !configuration.addAdditionalQueryItem.isEmpty {
                try configuration.addAdditionalQueryItem.forEach { urlComponents.queryItems?.append( try $0()) }
            }
            urlRequest.url = urlComponents.url
        }else {
            throw ParameterEncoderError.urlEncodingFailed
        }
    }
    
    public func JSONParameterEncoder(bodyParameters: Parameters?) throws {
        guard let bodyParameters = bodyParameters,
              !bodyParameters.isEmpty else { throw ParameterEncoderError.bodyParametersNil }
        do {
            let jsonAsData = try JSONSerialization.data(withJSONObject: bodyParameters,
                                                        options: configuration.jsonSerializationWritingOptions)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil && !configuration.addDeafultHeader {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }else {
                try self.addAdditionalHeaders(configuration.deafultHeader)
            }
        }catch {
            throw ParameterEncoderError.bodyEncodingFailed
        }
    }
}
