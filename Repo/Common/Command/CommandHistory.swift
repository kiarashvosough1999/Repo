//
//  CommandHistory.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

final internal class CommandHistory {
    
    private let queueLabel = "CommandHistoryLabel"
    
    private lazy var group:DispatchGroup = {
        DispatchGroup()
    }()
    private lazy var queue:DispatchQueue = {
        DispatchQueue(label: queueLabel)
    }()
    
    private var commands = Queue<DispatchWorkerProtocol>()
    
    deinit {
        cancelAllCommands()
    }
    func setCommand(wait after:TimeInterval = 0.0, _ execute: @escaping () -> ()) {
        group.enter()
        queue.async { [weak self] in
            guard let self = self else {
                fatalError(
                    """
                    CommandHistory was dealocated cannot execute command
                    """
                )
            }
            _ = self.group.wait(timeout: .now() + after)
            execute()
            self.group.leave()
        }
    }
    
    func setCommand(wait after: TimeInterval = 0.0, _ execute: DispatchWorkerProtocol) {
        commands <- execute
        queue.async { [weak self] in
            guard let self = self else {
                fatalError(
                    """
                    CommandHistory was dealocated cannot execute command
                    """
                )
            }
            _ = execute.waitSync(timeout: .now() + after)
            execute.perform(on: self.queue)
            --self.commands
        }
    }
    
    func cancelAllCommands() {
        commands.forEach { $0.cancel() }
    }
    
    private func undo(with commandType: DispatchWorker.Type) throws {
        guard let command = commands.first else {
            throw CommandError.noCommandFound(
                """
                last command is unavailable, it might be completed and dequeued
                """
            )
        }
        guard type(of: command) == commandType else {
            throw CommandError.wrongType(
            """
            last command was not of type\(commandType)
            it was of type\(type(of: command))
            """
            )
        }
        command.cancel()
    }
}

extension CommandHistory {
    
    internal enum  CommandError: Error {
        case noCommandFound(String)
        case wrongType(String)
    }
    
    internal enum EditAction {
        case cancelLast
        case cancelFirst
        case cancelAll
    }
    
    internal enum Action {
        case await(action:EditAction)
        case cancel(action:EditAction)
        case start(action:EditAction)
        case compelete(action:EditAction)
        case suspend(action:EditAction)
    }
}
