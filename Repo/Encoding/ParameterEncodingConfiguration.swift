//
//  ParameterEncodingConfiguration.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/19/1400 AP.
//

import Foundation

public struct ParameterEncodingConfiguration: ParameterEncodingConfigurationProtocols {
    
    public init(urlComponentsConfigurator: ParameterEncodingConfiguration.URLComponentsConfigurator? = nil,
                addAdditionalQueryItem: [ParameterEncodingConfiguration.AddAdditionalQueryItem] = [],
                allowedCharachter: CharacterSet = .urlHostAllowed,
                jsonSerializationWritingOptions: JSONSerialization.WritingOptions = [.prettyPrinted],
                deafultHeader: HTTPHeaders = [:],
                addDeafultHeader: Bool = false) {
        self.urlComponentsConfigurator = urlComponentsConfigurator
        self.addAdditionalQueryItem = addAdditionalQueryItem
        self.allowedCharachter = allowedCharachter
        self.jsonSerializationWritingOptions = jsonSerializationWritingOptions
        self.deafultHeader = deafultHeader
        self.addDeafultHeader = addDeafultHeader
    }
    
    
    public var urlComponentsConfigurator:URLComponentsConfigurator?
    public var addAdditionalQueryItem:[AddAdditionalQueryItem] = []
    public var allowedCharachter:CharacterSet = .urlHostAllowed
    public var jsonSerializationWritingOptions:JSONSerialization.WritingOptions = [.prettyPrinted]
    public var deafultHeader:HTTPHeaders = [:]
    public var addDeafultHeader:Bool = false
    
}
