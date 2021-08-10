//
//  URLSessionTaskDelegate++SubjectProxy.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/10/1400 AP.
//

#if canImport(RxSwift)
import Foundation
import RxSwift

typealias willBeginDelayedRequestCompletionHandler = (URLSession.DelayedRequestDisposition, URLRequest?) -> Void

typealias URLRequestCompletionHandler = (URLRequest?) -> Void

typealias NewBodyStreamCompletionHandler = (InputStream?) -> Void

protocol URLSessionTaskDelegateSubjectProxy: URLSessionDelegateSubjectProxy {

    
    @available(iOS 11.0, *)
    var sessionTaskWillBeginDelayedRequestWithCompletionHandler:
        PublishSubject<(URLSession,URLSessionTask,URLRequest,willBeginDelayedRequestCompletionHandler)> { get }
    
    @available(iOS 11.0, *)
    var sessionTaskIsWaitingForConnectivityWithTask:
        PublishSubject<(URLSession,URLSessionTask)> { get }
    
    var sessionWithTaskWillPerformHTTPRedirectionFromResponseToNewRequestWithCompletionHandler:
        PublishSubject<(URLSession,URLSessionTask,HTTPURLResponse,URLRequest,URLRequestCompletionHandler)> { get }
    
    var sessionWithTaskDidReceiveChallengeWithCompletionHandler:
        PublishSubject<(URLSession,URLSessionTask,URLAuthenticationChallenge,ChallengeHandler)> { get }
    
    var sessionWithTaskNeedNewBodyStreamWithCompletionHandler:PublishSubject<(URLSession,URLSessionTask,NewBodyStreamCompletionHandler)> { get }
    
    var sessionWithTaskdidSendBodyData:PublishSubject<(URLSession,URLSessionTask,Int64,Int64,Int64)> { get }
    
    @available(iOS 10.0, *)
    var sessionWithTaskDidFinishCollectingMetrics:PublishSubject<(URLSession,URLSessionTask,URLSessionTaskMetrics)> { get }
    
    var sessionWithTaskDidCompleteWithError:PublishSubject<(URLSession,URLSessionTask,Error?)> { get }
}

extension URLSessionTaskDelegateSubjectProxy {
    
    
    @available(iOS 11.0, *)
    var sessionTaskWillBeginDelayedRequestWithCompletionHandler:
        PublishSubject<(URLSession,URLSessionTask,URLRequest,willBeginDelayedRequestCompletionHandler)>
        {
            PublishSubject<(URLSession,URLSessionTask,URLRequest,willBeginDelayedRequestCompletionHandler)>()
        }
    
    @available(iOS 11.0, *)
    var sessionTaskIsWaitingForConnectivityWithTask:
        PublishSubject<(URLSession,URLSessionTask)>
        {
            PublishSubject<(URLSession,URLSessionTask)>()
        }
    
    var sessionWithTaskWillPerformHTTPRedirectionFromResponseToNewRequestWithCompletionHandler:
        PublishSubject<(URLSession,URLSessionTask,HTTPURLResponse,URLRequest,URLRequestCompletionHandler)>
        {
            PublishSubject<(URLSession,URLSessionTask,HTTPURLResponse,URLRequest,URLRequestCompletionHandler)>()
        }
    
    var sessionWithTaskDidReceiveChallengeWithCompletionHandler:
        PublishSubject<(URLSession,URLSessionTask,URLAuthenticationChallenge,ChallengeHandler)> {
        PublishSubject<(URLSession,URLSessionTask,URLAuthenticationChallenge,ChallengeHandler)>()
    }
    
    var sessionWithTaskNeedNewBodyStreamWithCompletionHandler:PublishSubject<(URLSession,URLSessionTask,NewBodyStreamCompletionHandler)> {
        PublishSubject<(URLSession,URLSessionTask,NewBodyStreamCompletionHandler)>()
    }
    
    var sessionWithTaskdidSendBodyData:PublishSubject<(URLSession,URLSessionTask,Int64,Int64,Int64)> {
        PublishSubject<(URLSession,URLSessionTask,Int64,Int64,Int64)>()
    }
    
    @available(iOS 10.0, *)
    var sessionWithTaskDidFinishCollectingMetrics:PublishSubject<(URLSession,URLSessionTask,URLSessionTaskMetrics)> {
        PublishSubject<(URLSession,URLSessionTask,URLSessionTaskMetrics)>()
    }
    
    var sessionWithTaskDidCompleteWithError:PublishSubject<(URLSession,URLSessionTask,Error?)> {
        PublishSubject<(URLSession,URLSessionTask,Error?)>()
    }
}
#endif
