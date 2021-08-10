//
//  Method.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/16/1400 AP.
//

import Foundation

/// HTTP Method
public enum Method : String, RawFunctionCallable {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
}
