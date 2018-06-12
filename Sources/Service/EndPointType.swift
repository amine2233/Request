//
//  EndPointType.swift
//  Request iOS
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/**
 HTTP format type
 
 - json: Use json type format for request url
 - xml: Use xml type format for request url
 - yml: Use yml type format for request url
 */
public enum HTTPFormat: String {
    case json   = "json"
    case xml    = "xml"
    case yml    = "yml"
    case html   = "html"
}

/// Endpoint type configuration
public protocol EndPointType {
    
    /// Request base url
    var baseURL: URL { get }
    /// Path request
    var path: String { get }
    /// Format request
    var format: HTTPFormat { get }
    /// HTPP Method request
    var httpMethod: HttpMethod { get }
    /// Task request
    var task: HTTPTask { get }
    /// Header request
    var headers: HTTPHeaders? { get }
    /// Query parameters request
    var queriesParameters: Parameters? { get }
    /// Body parameters request
    var bodyParameters: Parameters? { get }
    /// Url parameters request
    var urlParameters: Parameters? { get }
    /// Encoder type request
    var encoder: ParameterEncoder? { get }
    /// Name request
    var name: String { get }
    /// Debug description request
    var dubugDescription: String { get }
    /// Debug mode for request
    var isDebug: Bool { get }
}

extension EndPointType {
    /// Debug description request
    var dubugDescription: String {
        return ""
    }
    
    /// Debug mode for request
    var isDebug: Bool {
        return false
    }
}
