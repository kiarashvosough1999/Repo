//
//  CommandOperation.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

internal protocol DispatchWorkerProtocol {
    
    var isCancelled: Bool { get }
    
    func perform(on inheritedQueue: DispatchQueue?)
    
    func perform(on inheritedQueue: DispatchQueue?,_ dispatchOption:DispathOption)
    
    func waitSync()
    
    @discardableResult
    func waitSync(timeout: DispatchTime) -> DispatchTimeoutResult
    
    func notify(qos: DispatchQoS,
                flags: DispatchWorkItemFlags,
                queue: DispatchQueue,
                execute: @escaping @convention(block) () -> Void)
    
    func notify(queue: DispatchQueue, execute: DispatchWorkItem)
    
    func cancel()
    
    init(qos: DispatchQoS,
         flags: DispatchWorkItemFlags,
         dispathOption:DispathOption,
         block: @escaping @convention(block) () -> Void)
    
    init(dispathOption: DispathOption,
         _ worker: DispatchWorkItem)
}

internal class DispatchWorker: DispatchWorkerProtocol  {
    
    private let dispathOption: DispathOption
    private let worker: DispatchWorkItem
    
    internal var isCancelled: Bool { worker.isCancelled }
    
    required internal init(qos: DispatchQoS = .unspecified,
         flags: DispatchWorkItemFlags = [],
         dispathOption:DispathOption,
         block: @escaping @convention(block) () -> Void){
        self.dispathOption = dispathOption
        self.worker = DispatchWorkItem(qos: qos,
                                       flags: flags,
                                       block: block)
    }
    
    required internal init(dispathOption: DispathOption,
         _ worker: DispatchWorkItem){
        self.dispathOption = dispathOption
        self.worker = worker
    }
    
    internal func perform(on inheritedQueue: DispatchQueue?){
        perform(on: inheritedQueue, self.dispathOption)
    }
    
    
    internal func perform(on inheritedQueue: DispatchQueue?,_ dispatchOption:DispathOption) {
        switch dispathOption {
            case .asyncWithInheritedQueue:
                guard let inheritedQueue = inheritedQueue else {
                    fatalError()
                }
                inheritedQueue.async(execute: worker)
                
            case let .asyncAfterWithInheritedQueue(deadline):
                guard let inheritedQueue = inheritedQueue else {
                    fatalError()
                }
                inheritedQueue.asyncAfter(deadline: .now() + deadline, execute: worker)
                
            case .syncWithInheritedQueue:
                inheritedQueue?.sync(execute: worker)
                
            case .none:
                fatalError()
                
            case let .sync(queue):
                queue.async(execute: worker)
                
            case .unsafeSync:
                worker.perform()
                
            case let .async(queue):
                queue.async(execute: worker)
                
            case let .asyncAfter(deadline, queue):
                queue.asyncAfter(deadline: .now() + deadline, execute: worker)
        }
    }

    internal func waitSync() { worker.wait() }

    internal func waitSync(timeout: DispatchTime) -> DispatchTimeoutResult { worker.wait(timeout: timeout) }


    internal func notify(qos: DispatchQoS = .unspecified,
                flags: DispatchWorkItemFlags = [],
                queue: DispatchQueue,
                execute: @escaping @convention(block) () -> Void){
        worker.notify(qos: qos,
                      flags: flags,
                      queue: queue, execute: execute)
    }

    internal func notify(queue: DispatchQueue, execute: DispatchWorkItem){
        worker.notify(queue: queue, execute: execute)
    }

    internal func cancel() { worker.cancel() }
    
}





final internal class AwaitCommand: DispatchWorker {
    
}

final internal class SuspendCommand: DispatchWorker {
    
}

final internal class CancelCommand: DispatchWorker {
    
}

final internal class CompeleteCommand: DispatchWorker {
    
}

final internal class StartCommand: DispatchWorker {
    
}
