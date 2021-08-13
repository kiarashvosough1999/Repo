//
//  DownloadTaskConfig.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation

public struct DownloadTaskConfig: DownloadTaskConfigurationProtocol {
    
    public var taskDescription: String?
    
    public var earliestBeginDate: Date?
    
    public var countOfBytesClientExpectsToSend: Int64?
    
    public var countOfBytesClientExpectsToReceive: Int64?
    
    public var priority: Float?
    
    public var prefersIncrementalDelivery: Bool?
    
    public init(taskDescription: String? = nil,
                earliestBeginDate: Date? = nil,
                countOfBytesClientExpectsToSend: Int64? = nil,
                countOfBytesClientExpectsToReceive: Int64? = nil,
                priority: Float? = nil,
                prefersIncrementalDelivery: Bool? = nil) {
        self.taskDescription = taskDescription
        self.earliestBeginDate = earliestBeginDate
        self.countOfBytesClientExpectsToSend = countOfBytesClientExpectsToSend
        self.countOfBytesClientExpectsToReceive = countOfBytesClientExpectsToReceive
        self.priority = priority
        self.prefersIncrementalDelivery = prefersIncrementalDelivery
    }
    
    public init() {}
}
