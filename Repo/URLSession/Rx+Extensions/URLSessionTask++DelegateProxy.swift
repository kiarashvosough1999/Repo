//
//  URLSessionTask++DelegateProxy.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/10/1400 AP.
//

#if canImport(RxSwift) && canImport(RxCocoa)

import RxSwift
import RxCocoa

class URLSessionTaskDelegateProxy<T>: DelegateProxy<T, URLSessionTaskDelegate>,
                                      URLSessionTaskDelegateSubjectProxy,
                                      DelegateProxyType,
                                      URLSessionDelegate where T: SessionControllable {
    
    
    public init(parentObject: T) {
        super.init(parentObject: parentObject, delegateProxy: URLSessionTaskDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { parent in
            URLSessionTaskDelegateProxy(parentObject: parent)
        }
    }
    
    static func currentDelegate(for object: T) -> URLSessionTaskDelegate? {
        object.taskDelegate
    }
    
    static func setCurrentDelegate(_ delegate: URLSessionTaskDelegate?, to object: T) {
        object.taskDelegate = delegate
    }
    
    
    //MARK: - Delegates
    
    func urlSession(_ session: URLSession, didBecomeInvalidWithError error: Error?) {
        sessionDidBecomeInvalidWithError.onNext((session, error))
    }
    
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        sessionDidReceiveChallengeWithCompletionHandler.onNext((session, challenge, completionHandler))
    }
    
    
    @available(iOS 7.0, *)
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        urlSessionDidFinishEventsForBackgroundURLSession.onNext(session)
    }
    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, task: URLSessionTask, willBeginDelayedRequest request: URLRequest, completionHandler: @escaping (URLSession.DelayedRequestDisposition, URLRequest?) -> Void) {
        sessionTaskWillBeginDelayedRequestWithCompletionHandler.onNext((session,task,request,completionHandler))
        
    }

    
    @available(iOS 11.0, *)
    func urlSession(_ session: URLSession, taskIsWaitingForConnectivity task: URLSessionTask){
        sessionTaskIsWaitingForConnectivityWithTask.onNext((session,task))
    }

    
    func urlSession(_ session: URLSession,
                             task: URLSessionTask,
                             willPerformHTTPRedirection response: HTTPURLResponse,
                             newRequest request: URLRequest,
                             completionHandler: @escaping (URLRequest?) -> Void) {
        sessionWithTaskWillPerformHTTPRedirectionFromResponseToNewRequestWithCompletionHandler.onNext((session,task,response,request,completionHandler))
    }

    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        sessionWithTaskDidReceiveChallengeWithCompletionHandler.onNext((session,task,challenge,completionHandler))
    }

    
    func urlSession(_ session: URLSession,
                             task: URLSessionTask,
                             needNewBodyStream completionHandler: @escaping (InputStream?) -> Void){
        sessionWithTaskNeedNewBodyStreamWithCompletionHandler.onNext((session,task,completionHandler))
    }

    
    func urlSession(_ session: URLSession,
                             task: URLSessionTask,
                             didSendBodyData bytesSent: Int64,
                             totalBytesSent: Int64,
                             totalBytesExpectedToSend: Int64) {
        sessionWithTaskdidSendBodyData.onNext((session,task,bytesSent,totalBytesSent,totalBytesExpectedToSend))
    }

    
    @available(iOS 10.0, *)
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didFinishCollecting metrics: URLSessionTaskMetrics) {
        sessionWithTaskDidFinishCollectingMetrics.onNext((session,task,metrics))
    }

    
    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?){
        sessionWithTaskDidCompleteWithError.onNext((session,task,error))
    }
}

extension Reactive where Base: SessionControllable  {
    
    var sessionDidBecomeInvalidWithError:Observable<(URLSession,Error?)> {
        return URLSessionDelegateProxy.proxy(for: base)
            .sessionDidBecomeInvalidWithError
            .asObservable()
    }
    
    var sessionDidReceiveChallengeWithCompletionHandler:Observable<(URLSession,URLAuthenticationChallenge,ChallengeHandler)> {
        return URLSessionDelegateProxy.proxy(for: base)
            .sessionDidReceiveChallengeWithCompletionHandler
            .asObservable()
    }
    
    var urlSessionDidFinishEventsForBackgroundURLSession:Observable<URLSession> {
        return URLSessionDelegateProxy.proxy(for: base)
            .urlSessionDidFinishEventsForBackgroundURLSession
            .asObservable()
    }
    
}

#endif
