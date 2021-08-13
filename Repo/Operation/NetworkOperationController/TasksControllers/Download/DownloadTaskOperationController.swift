//
//  DownloadTaskOperationController.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/14/1400 AP.
//

import Foundation

public final class DownloadTaskOperationController: OperationController<URLSessionDownloadTask,DownloadTaskConfig> {

    override var onExecuting: WorkerItemBlock? {
        return {
            WorkerItem(dispathOption: .asyncWithInheritedQueue) { [weak self] in
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
            WorkerItem(dispathOption: .asyncWithInheritedQueue) { [weak self] in
                guard let self = self else { fatalError("Unable to execute suspend block") }
                self.task?.suspend()
                
            }
        }
    }
    
    @discardableResult
    public func cancel(byProducingResumeData completionHandler: @escaping (Data?) -> Void) -> Self {
        task?.cancel(byProducingResumeData: completionHandler)
        return self
    }
}

extension DownloadTaskOperationController: DownloadTaskOperationControllerProtocol {}
