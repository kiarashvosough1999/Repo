//
//  TaskWrapper.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/15/1400 AP.
//

import Foundation

struct TaskWrapper<T> {
    
    let task: (@escaping finishHandler) throws -> T
    typealias finishHandler = () throws -> Void
}
