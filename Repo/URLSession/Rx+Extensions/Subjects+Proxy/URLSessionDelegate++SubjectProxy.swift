//
//  URLSessionDelegate++SubjectProxy.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

#if canImport(RxSwift)

import Foundation
import RxSwift

typealias ChallengeHandler = (URLSession.AuthChallengeDisposition, URLCredential?) -> Void

protocol URLSessionDelegateSubjectProxy {
    var sessionDidBecomeInvalidWithError: PublishSubject<(URLSession,Error?)> { get }
    var sessionDidReceiveChallengeWithCompletionHandler: PublishSubject<(URLSession,URLAuthenticationChallenge,ChallengeHandler)> { get}
    
    @available(iOS 7.0, *)
    var urlSessionDidFinishEventsForBackgroundURLSession: PublishSubject<URLSession> { get } }

extension URLSessionDelegateSubjectProxy {
    
    var sessionDidBecomeInvalidWithError:PublishSubject<(URLSession,Error?)> { PublishSubject<(URLSession,Error?)>() }
    var sessionDidReceiveChallengeWithCompletionHandler: PublishSubject<(URLSession,URLAuthenticationChallenge,ChallengeHandler)> { PublishSubject<(URLSession,URLAuthenticationChallenge,ChallengeHandler)>()}
    
    @available(iOS 7.0, *)
    var urlSessionDidFinishEventsForBackgroundURLSession: PublishSubject<URLSession> { PublishSubject<URLSession>() }
}

#endif
