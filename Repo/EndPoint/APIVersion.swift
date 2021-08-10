//
//  APIVersion.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/19/1400 AP.
//

import Foundation

/// Providing version on URLRequest path
public enum APIVersion: String, RawFunctionCallable {
    case none = ""
    case v1 = "/v1"
}
