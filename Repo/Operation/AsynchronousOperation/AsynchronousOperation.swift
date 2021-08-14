//
//  AsynchronousOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation


public protocol ConfigurableOperation {
    var operationConfiguration: OperationConfig { get }
    func changeOperationConfig(_ config: (inout OperationConfig) -> ()) throws -> Self
}
#warning("This class will be soon removed")
public class AsynchronousOperation: StateFullOperation,
                                    AsynchronousOperationProtocol,
                                    ConfigurableOperation,
                                    CommandExecutable {
    
    internal private(set) lazy var commandHistory:CommandHistory = {
        CommandHistory()
    }()
    
    /// Custome configuration which user can modify to change the operation behavior
    public private(set) var operationConfiguration: OperationConfig
    
    //MARK: - Init
    
    internal init(operationQueue: OperationQueue,
                  operationConfiguration: OperationConfig) {
        self.operationConfiguration = operationConfiguration
        super.init(operationQueue: operationQueue)
        self.operationState.context = self
        self.setOperationConfigurationChanges()
    }
    
    /// User can call this function on result of request `before` the `await` function been called to modify configuration
    /// - Parameter config: Configuration associated with `this` `Operation`
    /// - Returns: Self
    public func changeOperationConfig(_ config: (inout OperationConfig) -> ()) throws -> Self {
        guard operationState.canModifyOperationConfig else {
            throw OperationError.cantChangeOperationConfigOnCurrentState(String(describing: operationState.self))
        }
        config(&self.operationConfiguration)
        setOperationConfigurationChanges()
        return self
    }
    
    internal func setOperationConfigurationChanges() {
        self.queuePriority = operationConfiguration [keyPath:\.queuePriority]
        self.qualityOfService = operationConfiguration [keyPath:\.qualityOfService]
        self.name = operationConfiguration[keyPath:\.identifierGenerator]().rawValue
    }
}
