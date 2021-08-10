//
//  ParameterEncodingConfiguration++Protocols.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/19/1400 AP.
//

import Foundation

public protocol ParameterEncodingConfigurationProtocols {
    
    typealias URLComponentsConfigurator = (inout URLComponents) throws -> Void
    typealias AddAdditionalQueryItem = () throws -> (URLQueryItem)
    
    var urlComponentsConfigurator:URLComponentsConfigurator? { get set }
    var addAdditionalQueryItem:[AddAdditionalQueryItem] { get set }
    var allowedCharachter:CharacterSet { get set }
    var jsonSerializationWritingOptions:JSONSerialization.WritingOptions { get set }
    var deafultHeader:HTTPHeaders { get set }
    var addDeafultHeader:Bool { get set }
}
