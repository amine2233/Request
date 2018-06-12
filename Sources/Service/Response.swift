//
//  Response.swift
//  Request iOS
//
//  Created by Amine Bensalah on 09/06/2018.
//

import Foundation

public enum StatusCode {
    case ok
    case success(statusCode: Int)
    case notFound
    case apiError(statusCode: Int)
    case serverError(statusCode: Int)
    case authentification
    case authorisation
    case other(statusCode: Int)
    
    public init(statusCode: Int) {
        switch statusCode {
        case 200:
            self = .ok
        case 201...226:
            self = .success(statusCode: statusCode)
        case 401:
            self = .authentification
        case 403:
            self = .authorisation
        case 404:
            self = .notFound
        case 400...499:
            self = .apiError(statusCode: statusCode)
        case 500...527:
            self = .serverError(statusCode: statusCode)
        default:
            self = .other(statusCode: statusCode)
        }
    }
    
    public var emoji: String {
        switch self {
        case .ok,.success:
            return "✅"
        case .authentification,.authorisation:
            return "🔑"
        default:
            return "❌"
        }
    }
}

extension StatusCode: CustomStringConvertible {
    public var description: String {
        return ""
    }
}

extension StatusCode: CustomDebugStringConvertible {
    public var debugDescription: String {
        return ""
    }
}

public protocol ResponseProtocol {
    associatedtype DataModel
    
    var statusCode: Int { get }
    var statusCodeType: StatusCode { get }
    var headerFields: [AnyHashable : Any] { get }
    var endPoint: EndPointType { get }

    var response: HTTPURLResponse? { get }
    var data: Data? { get }
    var dataObject: DataModel? { get }
    
}

public struct Response<T>: ResponseProtocol {
    
    public typealias DataModel = T
    
    public let statusCode: Int
    
    public let statusCodeType: StatusCode
    
    public let endPoint: EndPointType
    
    public let response: HTTPURLResponse?
    
    public var dataObject: DataModel?
    
    public var data: Data?
    
    public let headerFields: [AnyHashable : Any]
    
    
    
    public init(with endPoint: EndPointType, urlResponse: URLResponse?) {
        self.endPoint = endPoint
        self.response = urlResponse as? HTTPURLResponse
        self.statusCode = self.response?.statusCode ?? 0
        self.headerFields = self.response?.allHeaderFields ?? [:]
        self.statusCodeType = StatusCode(statusCode: self.response?.statusCode ?? 0)
    }
    
    public init<Model>(with endPoint: EndPointType, urlResponse: URLResponse?, data: Data?, completion: ((Data?) -> Model?)? = nil) {
        self.init(with: endPoint, urlResponse: urlResponse)
        self.handleData(data: data, completion: completion)
    }
    
    public mutating func handleData<Model>(data: Data?, completion: ((Data?) -> Model?)?) {
        self.data = data
        switch self.statusCodeType {
        case .ok:
            self.dataObject = completion?(data) as? T
        default:
            self.data = nil
        }
    }
    
    public init(with endPoint: EndPointType, urlResponse: URLResponse?, data: Data?, dataObject: T?) {
        self.init(with: endPoint,urlResponse: urlResponse)
        self.data = data
        self.dataObject = dataObject
    }
}
