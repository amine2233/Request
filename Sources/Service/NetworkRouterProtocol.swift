//
//  NetworkRouter.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public typealias NetworkRouterCompletion = (_ data: Data?, _ response: URLResponse?, _ error: Error?) -> Swift.Void

public protocol NetworkRouterRequestProtocol {
    associatedtype EndPoint: EndPointType
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion)
    func jsonRequest<T: Codable>(_ router: EndPoint, _ type: T.Type, completion: @escaping ((_ data: T?, _ response: URLResponse?, _ error: Error?) -> Swift.Void))
    func cancel()
}

public protocol NetworkRouterDownloadProtocol {
    associatedtype EndPoint: EndPointType
    func download(_ router: EndPoint, completion: @escaping NetworkRouterCompletion)
    func download(_ url: URL, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

public protocol NetworkRouterUploadProtocol {
    associatedtype EndPoint: EndPointType
    func upload(_ router: EndPoint, from: Data?, completion: @escaping NetworkRouterCompletion)
    func cancel()
}

public typealias NetworkRouterProtocol = NetworkRouterRequestProtocol & NetworkRouterDownloadProtocol & NetworkRouterUploadProtocol
