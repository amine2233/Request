//
//  NetworkRouter.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Swift.Void

protocol NetworkRouterProtocol {
    associatedtype EndPoint: EndPointType
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion)
    func cancel()
}
