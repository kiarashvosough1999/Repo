//
//  CommandHistory.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

class CommandHistory {
    
    enum Action {
        case await
        case cancel
        case start
        case compelete
        case suspend
    }
    
    private var commandOperationQueue:OperationQueue
    
    internal init(commandOperationQueue: OperationQueue = OperationQueue(),
                  underlyingQueue:DispatchQueue) {
        self.commandOperationQueue = commandOperationQueue
        self.commandOperationQueue.maxConcurrentOperationCount = 1
        self.commandOperationQueue.underlyingQueue = underlyingQueue
    }
    
    deinit {
        commandOperationQueue.cancelAllOperations()
    }
    
    func set(_ command: CommandOperation) {
        commandOperationQueue
            .addOperation(
                command
            )
    }
    
    func cancel(last command: Action) {
        switch command {
            case .await:
                cancel(commandType: AwaitCommand.self)
            case .cancel:
                cancel(commandType: CancelCommand.self)
            case .start:
                cancel(commandType: StartCommand.self)
            case .compelete:
                cancel(commandType: CompeleteCommand.self)
            case .suspend:
                cancel(commandType: SuspendCommand.self)
        }
    }
    
    private func cancel(commandType: Operation.Type) {
        commandOperationQueue
            .operations
            .filter {
                return type(of: $0) == commandType
            }
            .forEach {
                $0.cancel()
            }
    }
}
