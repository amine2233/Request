//
//  HTTPTask.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public typealias HTTPHeaders = [String:String]

public enum HTTPTask {
    case request
    case requestParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoder, urlParameters: Parameters?, queryParameters: Parameters?)
    case requestParametersAndHeaders(bodyParameters: Parameters?, bodyEncoding: ParameterEncoder, urlParameters: Parameters?, queryParameters: Parameters?, additionHeaders: HTTPHeaders?)
    // case download, upload
}
