//
//  SafeOperation++Configuration.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/24/1400 AP.
//

import Foundation

public typealias OperationConfiguration = SafeOperation.Configuration

extension SafeOperation {
    
    public struct Configuration {
        
        public typealias OperationIdentifierGenerator = () -> OperationIdentifier
        
        public var identifier:OperationIdentifier
        public var queuePriority: Operation.QueuePriority = .normal
        public var qualityOfService: QualityOfService = .default
        public var waitUntilAllOperationsAreFinished: Bool = false
        
        public init(identifierGenerator: OperationIdentifierGenerator? = nil,
                    queuePriority: Operation.QueuePriority = .normal,
                    qualityOfService: QualityOfService = .default,
                    waitUntilAllOperationsAreFinished: Bool = false) {
            self.queuePriority = queuePriority
            self.qualityOfService = qualityOfService
            self.identifier =  identifierGenerator.on { generator in
                return generator()
            } none: {
                return OperationIdentifier(rawValue: UUID().uuidString)!
            }
        }
    }
}
