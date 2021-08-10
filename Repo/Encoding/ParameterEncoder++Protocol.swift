//
//  ParameterEncoder++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/19/1400 AP.
//

import Foundation

public protocol ParameterEncoderProtocol {
    var configuration: ParameterEncodingConfiguration { get set }
    var urlRequest:URLRequest { get set }
    func encode(bodyParameters: Parameters?,
                urlParameters: Parameters?,
                parameterEncoding:ParameterEncodingType) throws
    func encodeJustHeader() throws
    func URLParameterEncoder(urlParameters: Parameters?) throws
    func JSONParameterEncoder(bodyParameters: Parameters?) throws
    func addAdditionalHeaders(_ additionalHeaders: HTTPHeaders?) throws
}
