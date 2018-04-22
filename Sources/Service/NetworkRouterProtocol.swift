//
//  NetworkRouter.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// Network Router completion for response request
public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Swift.Void

/// Network router protocol, must all network router implement this protocol
public protocol NetworkRouterProtocol {
    
    /// Endpoint type
    associatedtype EndPoint: EndPointType
    
    /**
     Request method
     
     - Parameter router: The endpoint we will use for request
     - Parameter completion: completion for request method to get server response
     */
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion)
    
    /**
     Json request method
     
     - Parameter router: The endpoint we will use for request
     - Parameter type: The Codable type we will recive
     - Parameter completion: completion for request method to get server response
     */
    func jsonRequest<T: Codable>(_ router: EndPoint, _ type: T.Type, completion: @escaping ((_ data: T?, _ response: URLResponse?, _ error: Error?) -> Swift.Void))
    
    /**
     Download method
     
     - Parameter router: The endpoint we will use for download data
     - Parameter completion: completion for request method to get server response
     */
    func download(_ router: EndPoint, completion: @escaping NetworkRouterCompletion)
    
    /**
     Download method with url
     
     - Parameter url: The url for download data
     - Parameter completion: completion for request method to get server response
     */
    func download(_ url: URL, completion: @escaping NetworkRouterCompletion)
    
    /**
     Request method to upload data
     
     - Parameter router: The endpoint we will use for upload data
     - Parameter from: The data we will upload to server
     - Parameter completion: completion for request method to get server response
     */
    func upload(_ router: EndPoint, from: Data?, completion: @escaping NetworkRouterCompletion)
    
    /// Cancel request task
    func cancel()
}
