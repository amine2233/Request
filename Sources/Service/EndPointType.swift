//
//  EndPointType.swift
//  Request iOS
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public enum HTTPFormat: String {
    case json = "json"
    case xml = "xml"
    case yml = "yml"
}

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var format: HTTPFormat { get }
    var httpMethod: HttpMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
    var queriesParameters: Parameters? { get }
    var bodyParameters: Parameters? { get }
    var urlParameters: Parameters? { get }
    var encoder: ParameterEncoder? { get }
    var name: String { get }
    var dubugDescription: String { get }
}

extension EndPointType {
    var dubugDescription: String {
        return ""
    }
}
