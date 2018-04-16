//
//  NetworkEnvironment.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public protocol NetworkEnvironmentProtocol {
    var apiBaseURL: String { get }
    var apiClientToken: String? { get }
    var apiClientSecret: String? { get }
    var name: String { get }
    var debug: Bool { get }
    var baseUrl: String { get }
    var isHTTPS: Bool { get }
}

extension NetworkEnvironmentProtocol {
    public var apiAbsoluteURL: String {
        if self.apiBaseURL.hasPrefix("http") {
            return self.apiBaseURL
        } else {
            return "\(isHTTPS ? "https": "http")://\(self.apiBaseURL)"
        }
    }
    
    public var absoluteURL: String {
        if self.baseUrl.hasPrefix("http") {
            return self.apiBaseURL
        } else {
            return "\(isHTTPS ? "https": "http")://\(self.apiBaseURL)"
        }
    }
    
    public var description: String {
        return "Environment: \(self.name)"
    }
}
