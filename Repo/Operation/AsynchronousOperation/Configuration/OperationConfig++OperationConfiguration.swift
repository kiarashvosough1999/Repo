//
//  OperationConfig++OperationConfiguration.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation


public protocol OperationConfiguration {
    typealias OperationIdentifierGenerator = () -> OperationIdentifier
    
    var uuid:UUID { get set }
    var identifierGenerator:OperationIdentifierGenerator { get set }
    var queuePriority: Operation.QueuePriority { get set }
    var qualityOfService: QualityOfService { get set }
    var waitUntilAllOperationsAreFinished: Bool { get set }
}
