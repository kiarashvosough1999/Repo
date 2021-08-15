//
//  AsynchronousOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

#warning("This class will be soon removed")
public class NetworkAsyncOperation: StateFullOperation,
                                    NetworkAsyncOperatable,
                                    CommandExecutable {
    
    internal private(set) lazy var commandHistory:CommandHistory = {
        CommandHistory()
    }()

    //MARK: - Init
    
    override init(operationQueue: OperationQueue?,
                  configuration: OperationConfiguration,
                  operationState: OperationStateProtocol = OperationReadyState(queueState: .init(enqueued: false))) {
        super.init(operationQueue: operationQueue, configuration: configuration, operationState: operationState)
        self.operationState.context = self
    }
}
