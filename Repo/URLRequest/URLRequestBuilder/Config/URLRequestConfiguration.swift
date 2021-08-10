//
//  URLRequestConfiguration.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/7/1400 AP.
//

import Foundation

public struct URLRequestConfiguration: URLRequestConfigurationProtocol {
    
    public private(set) var setDeafultEncoder: Bool = true
    
    public private(set) var httpShouldHandleCookies: Bool = false
    
    public private(set) var httpShouldUsePipelining: Bool = false
    
    public private(set) var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    public private(set) var timeoutInterval: TimeInterval = 5
    
    public private(set) var networkServiceType: URLRequest.NetworkServiceType = .default
    
    public private(set) var allowsCellularAccess: Bool = false
    
    public private(set) var allowsExpensiveNetworkAccess: Bool = false
    
    public private(set) var allowsConstrainedNetworkAccess: Bool = false
    
    public private(set) var assumesHTTP3Capable: Bool = false
    
    public init(httpShouldHandleCookies: Bool = false,
                httpShouldUsePipelining: Bool = false,
                cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: TimeInterval = 5,
                networkServiceType: URLRequest.NetworkServiceType = .default,
                allowsCellularAccess: Bool = false,
                allowsExpensiveNetworkAccess: Bool = false,
                allowsConstrainedNetworkAccess: Bool = false,
                assumesHTTP3Capable: Bool = false) {
        self.httpShouldHandleCookies = httpShouldHandleCookies
        self.httpShouldUsePipelining = httpShouldUsePipelining
        self.cachePolicy = cachePolicy
        self.timeoutInterval = timeoutInterval
        self.networkServiceType = networkServiceType
        self.allowsCellularAccess = allowsCellularAccess
        self.allowsExpensiveNetworkAccess = allowsExpensiveNetworkAccess
        self.allowsConstrainedNetworkAccess = allowsConstrainedNetworkAccess
        self.assumesHTTP3Capable = assumesHTTP3Capable
    }
}

public protocol URLRequestConfigurationProtocol {
    
    var setDeafultEncoder:Bool { get }
    
    var cachePolicy: URLRequest.CachePolicy { get }
    
    var timeoutInterval: TimeInterval { get }
    
    @available(macOS 10.7, iOS 4.0, *)
    var networkServiceType: URLRequest.NetworkServiceType { get }
    
    @available(macOS 10.8, iOS 6.0, *)
    var allowsCellularAccess: Bool { get }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    var allowsExpensiveNetworkAccess: Bool { get }
    
    @available(macOS 10.15, iOS 13.0, watchOS 6.0, tvOS 13.0, *)
    var allowsConstrainedNetworkAccess: Bool { get }
    
    @available(macOS 11.3, iOS 14.5, watchOS 7.4, tvOS 14.5, *)
    var assumesHTTP3Capable: Bool { get }
    
    var httpShouldHandleCookies: Bool { get }
    
    @available(macOS 10.7, iOS 4.0, *)
    var httpShouldUsePipelining: Bool { get }
}
