//
//  NetworkEnvironment.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// NetworkEnvironmentProtocol for create many environement is single app
public protocol NetworkEnvironmentProtocol {
    /// API url we will use this for create url request
    var apiBaseURL: String { get }
    /// API client token
    var apiClientToken: String? { get }
    /// API client secret
    var apiClientSecret: String? { get }
    /// Name of environement
    var name: String { get }
    /// Is debug or not environement
    var debug: Bool { get }
    /// Website url
    var baseUrl: String { get }
    /// If secure https or not
    var isHTTPS: Bool { get }
}

extension NetworkEnvironmentProtocol {
    
    /// Absolute api with adding https or http if it required
    public var apiAbsoluteURL: String {
        if self.apiBaseURL.hasPrefix("http") {
            return self.apiBaseURL
        } else {
            return "\(isHTTPS ? "https": "http")://\(self.apiBaseURL)"
        }
    }
    
    /// Absolute website url
    public var absoluteURL: String {
        if self.baseUrl.hasPrefix("http") {
            return self.apiBaseURL
        } else {
            return "\(isHTTPS ? "https": "http")://\(self.apiBaseURL)"
        }
    }
    
    /// Description of environement
    public var description: String {
        return "Environment: \(self.name)"
    }
}
