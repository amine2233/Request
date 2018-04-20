//
//  Request.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public protocol NetworkManagerProtocol {
    associatedtype EndPoint: EndPointType
    var network: NetworkRouter<EndPoint> { get }
    
    init(logger: NetworkLoggerProtocol)
}
