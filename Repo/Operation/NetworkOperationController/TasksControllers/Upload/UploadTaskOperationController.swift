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
            WorkerItem(dispathOption: .unsafeSync) { [weak self] in
                guard let self = self else { fatalError("Unable to execute executing block") }
                self.task?.resume()
            }
        }
    }
    
    override var onSuspended: WorkerItemBlock? {
        return {
            WorkerItem(dispathOption: .unsafeSync) { [weak self] in
                guard let self = self else { fatalError("Unable to execute suspend block") }
                self.task?.suspend()
                
            }
        }
    }
}

extension UploadTaskOperationController: UploadTaskOperationControllerProtocol {}
