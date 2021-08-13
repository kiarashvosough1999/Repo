//
//  UploadTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

public final class UploadTaskOperationController: OperationController<URLSessionUploadTask,UploadTaskConfig> {
    override var onExecuting: WorkerItemBlock? {
        return {
            WorkerItem(dispathOption: .async(queue: (self.operationQueue?.underlyingQueue)!)) { [weak self] in
                guard let self = self else { fatalError("Unable to execute executing block") }
                self.task?.resume()
                self.ob = self.progress?.observe(\.fractionCompleted,
                                                 options: .new,
                                                 changeHandler: { _, chng in
                                                    print(chng.newValue)
                })
                
            }
        }
    }
    var ob:NSKeyValueObservation?
    
    override var onSuspended: WorkerItemBlock? {
        return {
            WorkerItem(dispathOption: .async(queue: (self.operationQueue?.underlyingQueue)!)) { [weak self] in
                guard let self = self else { fatalError("Unable to execute suspend block") }
                self.task?.suspend()
                
            }
        }
    }
}

extension UploadTaskOperationController: UploadTaskOperationControllerProtocol {}
