//
//  EndPointType.swift
//  Request iOS
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public protocol EndPointType {
    var baseURL: URL { get }
    var path: String { get }
    var httpMethod: HttpMethod { get }
    var task: HTTPTask { get }
    var headers: HTTPHeaders? { get }
}
