//
//  URLSessionAnyTaskConfig.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation

public struct URLSessionAnyTaskConfig: URLSessionAnyTaskConfigurationProtocol {

    public var taskDescription: String?

    public var earliestBeginDate: Date?

    public var countOfBytesClientExpectsToSend: Int64?

    public var countOfBytesClientExpectsToReceive: Int64?

    public var priority: Float?

    public var prefersIncrementalDelivery: Bool?
}
