//
//  Request_iOSTests.swift
//  Request iOSTests
//
//  Created by Amine Bensalah on 16/04/2018.
//

import XCTest
@testable import Request

public enum Environement: String, NetworkEnvironmentProtocol {
    case develop = "develop"
    case production = "production"
    
    public var apiBaseURL: String {
        switch self {
        case .develop:
            return "localhost/~amine/web-welovemac/public/api/"
        case .production:
            return "welovemac.fr/api/"
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
            return "localhost/~amine/web-welovemac/public"
        case .production:
            return "welovemac.fr"
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
}

extension PostEndPoint: EndPointType {
    var baseURL: URL {
        guard let url = URL(string: Environement.develop.apiAbsoluteURL) else { fatalError("baseURL could not be configured.") }
        return url
    }
    
    var path: String {
        switch self {
        case .all:
            return "posts"
        case .get(let slug):
            return "/posts/\(slug)"
        }
    }
    
    var format: HTTPFormat {
        return .json
    }
    
    var httpMethod: HttpMethod {
        return .get
    }
    
    var task: HTTPTask {
        return .request
    }
    
    var headers: HTTPHeaders? {
        return nil
    }
    
    var queriesParameters: Parameters? {
        switch self {
        case .all(let page):
            return ["page": page]
        default:
            return nil
        }
    }
    
    var bodyParameters: Parameters? {
        return nil
    }
    
    var urlParameters: Parameters? {
        return nil
    }
    
    var encoder: ParameterEncoder? {
        return nil
    }
}

final class PostNetworkManager: NetworkManager {
    static let environment : Environement = .develop
    let router = Router<PostEndPoint>()
    
    
}



class Request_Tests: XCTestCase {
    
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        PostNetworkManager().router.request(.all(page: 2)) { (data, response, _) in
            print("response: ", response)
            if let data = data {
                do {
                    print("data: ", data)
                    let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
                    print("json: ", jsonData)
                } catch {
                    print("error:", error)
                }
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
