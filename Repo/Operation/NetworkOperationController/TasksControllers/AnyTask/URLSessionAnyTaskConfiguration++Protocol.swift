//
//  URLSessionAnyTaskConfiguration++Protocol.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/18/1400 AP.
//

import Foundation

public protocol URLSessionAnyTaskConfigurationProtocol {
    var taskDescription: String? { get set }
    
    @available(iOS 11.0, *)
    var earliestBeginDate: Date? { get set }
    
    @available(iOS 11.0, *)
    var countOfBytesClientExpectsToSend: Int64? { get set }
    
    @available(iOS 11.0, *)
    var countOfBytesClientExpectsToReceive: Int64? { get set }
    
    @available(iOS 8.0, *)
    var priority: Float? { get set }

    @available(iOS 14.5, *)
    var prefersIncrementalDelivery: Bool? { get set }
    
    init()
}
