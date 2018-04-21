//
//  Request.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// Network Manager Protocol use this protocol for all request class
public protocol NetworkManagerProtocol {
    /// Endpoint router type must only EndPointType
    associatedtype EndPoint: EndPointType
    
    /// Network router for request or download or upload
    var network: NetworkRouter<EndPoint> { get }
    
    /**
     NetworkManager initiliser
     
     - Parameter logger: NetworkLoggerProtocol for log all request
     */
    init(logger: NetworkLoggerProtocol)
}
