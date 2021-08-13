//
//  CommandOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

internal class CommandOperation: SafeOperation  {
    
    private var commands: [WorkerItem]
    
    internal init(on context:SafeOperation,
                  _ commands: [WorkerItem]) {
        self.commands = commands
        super.init(operationQueue: context.operationQueue)
    }
    
    override func main() {
        guard let queue = operationQueue?.underlyingQueue else {
            fatalError(
                """
                    underlyingQueue associated with operationQueue was found nil
                """
            )
        }
        
        commands.first?.notify(queue: queue) { [weak self] in
            guard let self = self else { fatalError("command operation dealocated") }
            self.isExecuting = false
            self.isFinished = true
        }
        
        commands.forEach { $0.perform(on: queue) }
    }
    
    internal override func cancel() {
        commands.forEach { $0.cancel() }
        super.cancel()
    }
}





final internal class AwaitCommand: CommandOperation {
    
}

final internal class SuspendCommand: CommandOperation {
    
}

final internal class CancelCommand: CommandOperation {
    
}

final internal class CompeleteCommand: CommandOperation {
    
}

final internal class StartCommand: CommandOperation {
    
}
