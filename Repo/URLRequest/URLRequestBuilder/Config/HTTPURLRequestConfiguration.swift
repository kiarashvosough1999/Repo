//
//  HTTPURLRequestConfiguration.swift
//  Repo
//
//  Created by Kiarash Vosough on 5/19/1400 AP.
//

import Foundation

public struct HTTPURLRequestConfiguration: HTTPURLRequestConfigurationProtocol {
    
    public private(set) var setDeafultEncoder:Bool = true
    
    public private(set) var httpShouldHandleCookies: Bool = false
    
    public private(set) var httpShouldUsePipelining: Bool = false
    
    public private(set) var cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData
    
    public private(set) var timeoutInterval: TimeInterval = 60
    
    public private(set) var networkServiceType: URLRequest.NetworkServiceType = .default
    
    public private(set) var allowsCellularAccess: Bool = false
    
    public private(set) var allowsExpensiveNetworkAccess: Bool = false
    
    public private(set) var allowsConstrainedNetworkAccess: Bool = false
    
    public private(set) var assumesHTTP3Capable: Bool = false
    
    public init(httpShouldHandleCookies: Bool = false,
                httpShouldUsePipelining: Bool = false,
                setDeafultEncoder:Bool = true,
                cachePolicy: URLRequest.CachePolicy = .reloadIgnoringLocalAndRemoteCacheData,
                timeoutInterval: TimeInterval = 5,
                networkServiceType: URLRequest.NetworkServiceType = .default,
                allowsCellularAccess: Bool = false,
                allowsExpensiveNetworkAccess: Bool = false,
                allowsConstrainedNetworkAccess: Bool = false,
                assumesHTTP3Capable: Bool = false) {
        self.setDeafultEncoder = setDeafultEncoder
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

public protocol HTTPURLRequestConfigurationProtocol: URLRequestConfigurationProtocol {

}
