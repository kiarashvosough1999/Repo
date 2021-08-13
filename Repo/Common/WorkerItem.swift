//
//  WorkerItem.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/21/1400 AP.
//

import Foundation

public enum DispathOption {
    case none
    case sync(queue: DispatchQueue)
    case syncWithInheritedQueue
    case asyncWithInheritedQueue
    case asyncAfterWithInheritedQueue(deadline: TimeInterval = 0)
    case asyncAfter(deadline: TimeInterval = 0,
                    queue: DispatchQueue)
    case async(queue: DispatchQueue)
    case unsafeSync
}

public struct WorkerItem {
    
    private let dispathOption: DispathOption
    private let worker: DispatchWorkItem
    
    var isCancelled: Bool { worker.isCancelled }
    
    public init(qos: DispatchQoS = .unspecified,
         flags: DispatchWorkItemFlags = [],
         dispathOption:DispathOption = .none,
         block: @escaping @convention(block) () -> Void){
        self.dispathOption = dispathOption
        self.worker = DispatchWorkItem(qos: qos,
                                       flags: flags,
                                       block: block)
    }
    
    public init(dispathOption: DispathOption = .none,
         _ worker: DispatchWorkItem){
        self.dispathOption = dispathOption
        self.worker = worker
    }
    
    public func perform(on inheritedQueue: DispatchQueue?){
        perform(on: inheritedQueue, self.dispathOption)
    }
    
    public func perform(on inheritedQueue: DispatchQueue?,_ dispatchOption:DispathOption) {
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

    public func waitSync() { worker.wait() }

    public func waitSync(timeout: DispatchTime) -> DispatchTimeoutResult { worker.wait(timeout: timeout) }


    public func notify(qos: DispatchQoS = .unspecified,
                flags: DispatchWorkItemFlags = [],
                queue: DispatchQueue,
                execute: @escaping @convention(block) () -> Void){
        worker.notify(qos: qos,
                      flags: flags,
                      queue: queue, execute: execute)
    }

    public func notify(queue: DispatchQueue, execute: DispatchWorkItem){
        worker.notify(queue: queue, execute: execute)
    }

    public func cancel() { worker.cancel() }
    
}
