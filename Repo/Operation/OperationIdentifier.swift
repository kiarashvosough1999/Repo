//
//  OperationIdentifier.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

public struct OperationIdentifier: RawFunctionCallable, Hashable {
    
    public typealias RawValue = String
    
    public var rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
    
    static let simple = OperationIdentifier(rawValue: "simple")!
}


internal protocol RawFunctionCallable: RawRepresentable {
    func callAsFunction() -> RawValue
}

internal extension RawFunctionCallable {
    func callAsFunction() -> RawValue {
        rawValue
    }
}
