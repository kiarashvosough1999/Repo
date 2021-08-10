//
//  NetworkOperationController++NetworkOperationBase.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public protocol TaskOperationControllerBaseProtocol: AsynchronousOperationProtocol {
    
    var taskDescription: String? { get }
    
    var taskState: URLSessionTask.State? { get }
    
    @available(iOS 7.0, *)
    var progress: Progress? { get }
    
    var taskIdentifier: Int? { get }

    var originalRequest: URLRequest? { get }

    var currentRequest: URLRequest? { get }

    var response: URLResponse? { get }

    @available(iOS 11.0, *)
    var earliestBeginDate: Date? { get }

    @available(iOS 11.0, *)
    var countOfBytesClientExpectsToSend: Int64? { get }

    @available(iOS 11.0, *)
    var countOfBytesClientExpectsToReceive: Int64? { get }

    var countOfBytesReceived: Int64? { get }

    var countOfBytesSent: Int64? { get }

    var countOfBytesExpectedToSend: Int64? { get }

    var countOfBytesExpectedToReceive: Int64? { get }

    var error: Error? { get }

    @available(iOS 8.0, *)
    var priority: Float? { get }

    @available(iOS 14.5, *)
    var prefersIncrementalDelivery: Bool? { get }
}
