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
        case 201 ... 226:
            self = .success(statusCode: statusCode)
        case 401:
            self = .authentification
        case 403:
            self = .authorisation
        case 404:
            self = .notFound
        case 400 ... 499:
            self = .apiError(statusCode: statusCode)
        case 500 ... 527:
            self = .serverError(statusCode: statusCode)
        default:
            self = .other(statusCode: statusCode)
        }
    }

    public var emoji: String {
        switch self {
        case .ok, .success:
            return "✅"
        case .authentification, .authorisation:
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

public protocol ResponseProtocol: class {
    associatedtype DataModel

    var statusCode: Int { get }
    var statusCodeType: StatusCode { get }
    var headerFields: [AnyHashable: Any] { get }
    var endPoint: EndPointType { get }

    var response: HTTPURLResponse? { get }
    var data: Data? { get }
    var dataObject: DataModel? { get }
    
    var context: CoreDataContextProtocol? { get }
}

public class Response<T>: ResponseProtocol {
    public typealias DataModel = T

    public let statusCode: Int

    public let statusCodeType: StatusCode

    public let endPoint: EndPointType

    public let response: HTTPURLResponse?

    public var dataObject: DataModel?

    public var data: Data?

    public let headerFields: [AnyHashable: Any]
    
    public let context: CoreDataContextProtocol?

    public init(with endPoint: EndPointType, urlResponse: URLResponse?, context: CoreDataContextProtocol?) {
        self.endPoint = endPoint
        self.response = urlResponse as? HTTPURLResponse
        self.context = context
        self.statusCode = response?.statusCode ?? 0
        self.headerFields = response?.allHeaderFields ?? [:]
        self.statusCodeType = StatusCode(statusCode: response?.statusCode ?? 0)
    }

    public convenience init(with endPoint: EndPointType, urlResponse: URLResponse?, context: CoreDataContextProtocol?, data: Data?, completion: ((Data?) -> DataModel?)? = nil) {
        self.init(with: endPoint, urlResponse: urlResponse, context: context)
        handleData(data: data, completion: completion)
    }

    public func handleData(data: Data?, completion: ((Data?) -> DataModel?)?) {
        self.data = data
        switch statusCodeType {
        case .ok, .success:
            dataObject = completion?(data)
        default:
            break
        }
    }

    public convenience init(with endPoint: EndPointType, urlResponse: URLResponse?, context: CoreDataContextProtocol?, data: Data?, dataObject: DataModel?) {
        self.init(with: endPoint, urlResponse: urlResponse, context: context)
        self.data = data
        self.dataObject = dataObject
    }
}
