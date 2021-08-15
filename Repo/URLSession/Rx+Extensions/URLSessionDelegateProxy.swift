//
//  URLSessionDelegateProxy.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

#if canImport(RxSwift) && canImport(RxCocoa)
import Foundation
import RxSwift
import RxCocoa

class URLSessionDelegateProxy<T>: DelegateProxy<T, URLSessionDelegate>,
                               URLSessionDelegateSubjectProxy,
                               DelegateProxyType,
                               URLSessionDelegate where T: SessionControllable {
    
    
    public init(parentObject: T) {
        super.init(parentObject: parentObject, delegateProxy: URLSessionDelegateProxy.self)
    }
    
    static func registerKnownImplementations() {
        register { parent in
            URLSessionDelegateProxy(parentObject: parent)
        }
    }
    
    static func currentDelegate(for object: T) -> URLSessionDelegate? {
        object.delegate
    }
    
    static func setCurrentDelegate(_ delegate: URLSessionDelegate?, to object: T) {
        object.delegate = delegate
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
}

#endif
