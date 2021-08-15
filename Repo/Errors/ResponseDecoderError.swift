//
//  ResponseDecoderError.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

public enum ResponseDecoderError:Error {
    case nilData
    case networkError(NSError)
    case decodingError(DecodingError)
    case error
}
