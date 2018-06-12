//
//  EndPointTypeMock.swift
//  Request
//
//  Created by Amine Bensalah on 10/06/2018.
//

import Foundation
import Request

public enum Environement: String, NetworkEnvironmentProtocol {
    case develop = "develop"
    case production = "production"
    
    public var apiBaseURL: String {
        switch self {
        case .develop:
            return "welovemac.local/api/"
        case .production:
            return "welovemac.local/api/"
        }
    }
    
    public var apiClientToken: String?  {
        switch self {
        case .develop:
            return ""
        case .production:
            return ""
        }
    }
    
    public var apiClientSecret: String?  {
        switch self {
        case .develop:
            return ""
        case .production:
            return ""
        }
    }
    
    public var name: String  {
        return self.rawValue
    }
    
    public var debug: Bool  {
        switch self {
        case .develop:
            return true
        case .production:
            return false
        }
    }
    
    public var baseUrl: String  {
        switch self {
        case .develop:
            return "welovemac.local"
        case .production:
            return "welovemac.local"
        }
    }
    
    public var isHTTPS: Bool  {
        switch self {
        case .develop:
            return false
        case .production:
            return false
        }
    }
}

enum PostEndPoint {
    case all(page: Int)
    case get(slug: String)
    case search(query: String)
    case thumb(image: String)
    case picture(image: String)
}

struct PostRouter: EndPointType {
    
    var endPoint: PostEndPoint
    var environement: Environement
    
    init(_ endpoint: PostEndPoint, environement: Environement) {
        self.endPoint = endpoint
        self.environement = environement
    }
    
    public var baseURL: URL {
        guard let url = URL(string: self.environement.apiAbsoluteURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    public var path: String {
        switch endPoint {
        case .all:
            return "posts"
        case .get(let slug):
            return "posts/\(slug)"
        case .search:
            return "search"
        case .thumb(let image):
            return "uploads/images/posts_thumb/\(image)"
        case .picture(let image):
            return "uploads/images/posts/\(image)"
        }
    }
    
    public var format: HTTPFormat {
        return .json
    }
    
    public var httpMethod: HttpMethod {
        switch endPoint {
        case .search:
            return .post
        default:
            return .get
        }
    }
    
    public var task: HTTPTask {
        switch endPoint {
        case .thumb, .picture:
            return .download
        default:
            return .request
        }
    }
    
    public var headers: HTTPHeaders? {
        return nil
    }
    
    public var queriesParameters: Parameters? {
        switch endPoint {
        case .all(let page):
            return ["page": page]
        case .search(let query):
            return ["query": query]
        default:
            return nil
        }
    }
    
    public var bodyParameters: Parameters? {
        return nil
    }
    
    public var urlParameters: Parameters? {
        return nil
    }
    
    public var encoder: ParameterEncoder? {
        return nil
    }
    
    public var name: String {
        switch endPoint {
        case .all:
            return "all"
        case .get:
            return "get"
        case .picture:
            return "picture"
        case .thumb:
            return "thumb"
        case .search:
            return "search"
        }
    }
    
    public var dubugDescription: String {
        switch endPoint {
        case .all(let page):
            return "\(self.name) post at page: \(page)"
        case .get(let slug):
            return "\(self.name) post with slug: \(slug)"
        case .picture(let image):
            return "\(self.name) post picture with slug: \(image)"
        case .thumb(let image):
            return "\(self.name) post thumb with slug: \(image)"
        case .search(let query):
            return "\(self.name) search with query: \(query)"
        }
    }
    
    public var isDebug: Bool {
        return self.environement.debug
    }
}
