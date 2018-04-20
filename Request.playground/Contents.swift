//: Playground - noun: a place where people can play

import Request

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
        return .get
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
        }
    }
    
    public var isDebug: Bool {
        return self.environement.debug
    }
}

final class PostNetworkManager: NetworkManagerProtocol {
    private(set) var network: NetworkRouter<PostRouter>
    
    public init(logger: NetworkLogger = NetworkLogger()) {
        self.network = NetworkRouter<PostRouter>(logger: logger)
    }
}

let allEndPoint = PostRouter.init(.all(page: 1), environement: .develop)
PostNetworkManager().network.request(allEndPoint) { (data, response, _) in
    print("response:", response!)
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

let endPoint = PostRouter.init(.get(slug: "post-1"), environement: .develop)
PostNetworkManager().network.request(endPoint) { (data, response, _) in
    print("response:", response!)
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

let pictureEndPoint = PostRouter.init(.picture(image: "post-1.jpg"), environement: .develop)
PostNetworkManager().network.download(endPoint) { (data, response, _) in
    print("response:", response!)
    if let data = data {
        do {
            print("data: ", data)
        } catch {
            print("error:", error)
        }
    }
}

