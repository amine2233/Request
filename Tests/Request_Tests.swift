//
//  Request_iOSTests.swift
//  Request iOSTests
//
//  Created by Amine Bensalah on 16/04/2018.
//

import XCTest
@testable import Request

class Request_Tests: XCTestCase {
    
    public struct Contact : Codable {
        
        var id : Int?
        var name : String?
        var subject : String?
        var email : String?
        var message : String?
        
        public enum CodingKeys: String, CodingKey {
            case id
            case name
            case subject
            case email
            case message
        }
        
        public init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            id = try values.decodeIfPresent(Int.self, forKey: .id)
            name = try values.decodeIfPresent(String.self, forKey: .name)
            subject = try values.decodeIfPresent(String.self, forKey: .subject)
            email = try values.decodeIfPresent(String.self, forKey: .email)
            message = try values.decodeIfPresent(String.self, forKey: .message)
        }
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(name, forKey: .name)
            try container.encode(subject, forKey: .subject)
            try container.encode(email, forKey: .email)
            try container.encode(message, forKey: .message)
        }
        
        init() {
            self.id = 0
            self.name = "amine"
            self.subject = "test"
            self.email = "amine.me@gmail.com"
            self.message = " is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset"
        }
        
        
    }
    
    enum ContactEndPoint {
        case post(contact: Contact)
    }
    
    struct ContactRouter: EndPointType {
        
        var endPoint: ContactEndPoint
        var environement: Environement
        var isDebug: Bool
        
        init(_ endPoint: ContactEndPoint, environement: Environement, isDebug: Bool = false) {
            self.endPoint = endPoint
            self.environement = environement
            self.isDebug = isDebug
        }
        
        var baseURL: URL {
            guard let url = URL(string: self.environement.apiAbsoluteURL) else { fatalError("baseURL could not be configured.") }
            return url
        }
        
        var path: String {
            switch endPoint {
            case .post:
                return "contacts"
            }
        }
        
        var format: HTTPFormat {
            return .json
        }
        
        var httpMethod: HttpMethod {
            return .post
        }
        
        var task: HTTPTask {
            return .request
        }
        
        var headers: HTTPHeaders? {
            switch endPoint {
            case .post:
                return [
                    "Content-Type": "application/json",
                    "Accept": "application/json"
                ]
            }
        }
        
        var queriesParameters: Parameters? {
            return nil
        }
        
        var bodyParameters: Parameters? {
            switch endPoint {
            case .post(let contact):
                //guard let jsonData = try? JSONEncoder().encode(contact) else { return nil }
                //guard let json = String(data: jsonData, encoding: String.Encoding.utf8) else { return nil }
                return ["appbundle_contact_contact": [
                    "name": contact.name ?? "null",
                    "subject": contact.subject ?? "null",
                    "message": contact.message ?? "null",
                    "email": contact.email ?? "null",
                    ]]
            }
        }
        
        /**
         
        */
        
        var urlParameters: Parameters? {
            return nil
        }
        
        var encoder: ParameterEncoder? {
            switch endPoint {
            case .post:
                return .jsonEncoding
            }
        }
        
        var name: String {
            switch endPoint {
            case .post:
                return "post"
            }
        }
        
        var dubugDescription: String {
            switch endPoint {
            case .post(let contact):
                return "\(self.name) \(contact)"
            }
        }
    }
    
    public enum Environement: String, NetworkEnvironmentProtocol {
        case develop = "develop"
        case production = "production"
        
        public var apiBaseURL: String {
            switch self {
            case .develop:
                return "welovemac.local/api/"
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
                return "welovemac.local"
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
    
    final class ContactNetworkManager: NetworkManagerProtocol {
        
        var network: NetworkRouter<ContactRouter>
        var environement: Environement = .production
        var isDebug: Bool = false
        
        public init(logger: NetworkLoggerProtocol) {
            self.network = NetworkRouter<ContactRouter>(logger: logger)
        }
        
        init(logger: NetworkLogger = NetworkLogger(), isDebug: Bool, environement: Environement) {
            self.network = NetworkRouter<ContactRouter>(logger: logger)
            self.isDebug = isDebug
            self.environement = environement
        }
        
        func post(contact: Contact, completion: @escaping (Contact?, URLResponse?, Error?) -> Void ) {
            let allEndPoint = ContactRouter.init(.post(contact: contact), environement: self.environement, isDebug: self.isDebug)
            self.network.jsonRequest(allEndPoint, Contact.self, completion: completion)
        }
    }

    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        let contact = ContactNetworkManager(isDebug: true, environement: .develop)
        contact.post(contact: Contact()) { (data, response, error) in
            if let error = error {
                print(error)
            } else {
                if let data = data {
                    print(data)
                } else {
                    print(response)
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
