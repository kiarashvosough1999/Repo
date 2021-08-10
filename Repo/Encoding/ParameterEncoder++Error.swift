//
//  ParameterEncoder++Error.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/19/1400 AP.
//

import Foundation

/// Encoding Error
public enum ParameterEncoderError: Error {
    case urlEncodingFailed
    case urlParametersNil
    case missingURL
    case bodyEncodingFailed
    case bodyParametersNil
    case headerParametersNil
}
