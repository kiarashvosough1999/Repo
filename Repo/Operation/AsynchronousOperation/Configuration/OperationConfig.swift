//
//  OperationConfig.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public struct OperationConfig: OperationConfiguration {
    
    public var uuid:UUID = UUID()
    public var identifierGenerator:OperationIdentifierGenerator
    public var queuePriority: Operation.QueuePriority = .normal
    public var qualityOfService: QualityOfService = .default
    public var waitUntilAllOperationsAreFinished: Bool = false
    
    public init(uuid: UUID = UUID(),
         waitUntilAllOperationsAreFinished: Bool = false,
         identifierGenerator: OperationConfig.OperationIdentifierGenerator? = nil,
         queuePriority: Operation.QueuePriority = .normal,
         qualityOfService: QualityOfService = .default) {
        self.uuid = uuid
        self.identifierGenerator = identifierGenerator == nil ?
            { OperationIdentifier(rawValue: uuid.uuidString)! }
            : identifierGenerator!
        self.queuePriority = queuePriority
        self.qualityOfService = qualityOfService
    }
}
