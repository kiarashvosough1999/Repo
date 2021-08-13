//
//  OperationIdentifier.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

/**
 
 This structure can be used to provide unique id for each operation
 
 It conforms to `RawFunctionCallable` which

 has rawvalue and use `()` on its properties to get its rawvalue.
 
 This can be extended and add more identifier for your own usage
 
 */
public struct OperationIdentifier: RawFunctionCallable, Hashable {
    
    public typealias RawValue = String
    
    public var rawValue: String
    
    public init?(rawValue: String) {
        self.rawValue = rawValue
    }
}

extension OperationIdentifier {
    
    static let simple = OperationIdentifier(rawValue: "simple")!
    static let data = OperationIdentifier(rawValue: "data")!
    static let download = OperationIdentifier(rawValue: "download")!
    static let upload = OperationIdentifier(rawValue: "upload")!
    static let websocket = OperationIdentifier(rawValue: "websocket")!
    static let stream = OperationIdentifier(rawValue: "stream")!
    
}
