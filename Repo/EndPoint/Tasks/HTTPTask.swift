//
//  HTTPTask.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

public enum HTTPTask {
    
    case request
    
    case requestParameters(bodyParameters: Parameters?,
                           bodyEncoding: ParameterEncodingType,
                           urlParameters: Parameters?)
    
    case requestParametersAndHeaders(bodyParameters: Parameters?,
                                     bodyEncoding: ParameterEncodingType,
                                     urlParameters: Parameters?,
                                     additionHeaders: HTTPHeaders?)
}
