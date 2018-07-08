//: Playground - noun: a place where people can play

import Request

public enum Environement: String, NetworkEnvironmentProtocol {
    case develop
    case production

    public var apiBaseURL: String {
        switch self {
        case .develop:
            return "localhost/~amine/web-welovemac/public/api/"
        case .production:
            return "welovemac.fr/api/"
        }
    }

    public var apiClientToken: String? {
        switch self {
        case .develop:
            return ""
        case .production:
            return ""
        }
    }

    public var apiClientSecret: String? {
        switch self {
        case .develop:
            return ""
        case .production:
            return ""
        }
    }

    public var name: String {
        return rawValue
    }

    public var debug: Bool {
        switch self {
        case .develop:
            return false
        case .production:
            return false
        }
    }

    public var baseUrl: String {
        switch self {
        case .develop:
            return "localhost/~amine/web-welovemac/public"
        case .production:
            return "welovemac.fr"
        }
    }

    public var isHTTPS: Bool {
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
        endPoint = endpoint
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
        case let .get(slug):
            return "posts/\(slug)"
        case let .thumb(image):
            return "uploads/images/posts_thumb/\(image)"
        case let .picture(image):
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
        case let .all(page):
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
        case let .all(page):
            return "\(name) post at page: \(page)"
        case let .get(slug):
            return "\(name) post with slug: \(slug)"
        case let .picture(image):
            return "\(name) post picture with slug: \(image)"
        case let .thumb(image):
            return "\(name) post thumb with slug: \(image)"
        }
    }

    public var isDebug: Bool {
        return environement.debug
    }
}

final class PostNetworkManager: NetworkManagerProtocol {
    init(logger: NetworkLoggerProtocol) {
        network = NetworkRouter<PostRouter>(logger: logger)
    }

    private(set) var network: NetworkRouter<PostRouter>

    public init(logger: NetworkLogger = NetworkLogger()) {
        network = NetworkRouter<PostRouter>(logger: logger)
    }
}

let allEndPoint = PostRouter(.all(page: 1), environement: .develop)
try? PostNetworkManager().network.request(allEndPoint) { data, _, _ in
    if let data = data {
        do {
            print("data 1: ", data)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print("json 1: ", jsonData)
        } catch {
            print("error 1:", error)
        }
    }
}

let endPoint = PostRouter(.get(slug: "post-1"), environement: .develop)
try? PostNetworkManager().network.request(endPoint) { data, _, _ in
    if let data = data {
        do {
            print("data 2: ", data)
            let jsonData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers)
            print("json 2: ", jsonData)
        } catch let error {
            print("error 2:", error)
        }
    }
}

let pictureEndPoint = PostRouter(.picture(image: "post-1.jpg"), environement: .develop)
try? PostNetworkManager().network.download(endPoint) { data, _, _ in
    if let data = data {
        do {
            print("data 3: ", data)
        } catch let error {
            print("error 3:", error)
        }
    }
}

let allEndPoint2 = PostRouter(.all(page: 1), environement: .develop)
let result: (Response<Data>?, Error?)? = try? PostNetworkManager().network.syncResponse(allEndPoint2)
do {
    let json = try JSONSerialization.jsonObject(with: result!.0!.data!, options: .mutableContainers)
    print("sync json 4:", json)
} catch let error {
    print("sync error 4:", error)
}
