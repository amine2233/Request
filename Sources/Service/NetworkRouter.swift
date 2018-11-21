#if canImport(Foundation)
import Foundation

/// The Network Router use it for request endpoint type
public class NetworkRouter<EndPoint: EndPointType>: NetworkRouterProtocol {
    
    /// The url session task
    private var task: URLSessionDataTaskProtocol?

    /// The natif url session
    fileprivate var session: URLSessionProtocol
    
    /// The core data context
    fileprivate var context: CoreDataContextProtocol?

    /// The network logger
    public private(set) var logger: NetworkLoggerProtocol?

    /**
     The network router initializer

     - Parameter logger: The Network logger

     - Returns: The NetworkRouter Object
     */
    public init(session: URLSessionProtocol? = nil, logger: NetworkLoggerProtocol? = nil, context: CoreDataContextProtocol? = nil) {
        self.session = session ?? URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue())
        self.logger = logger
        self.context = context
    }

    public func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) throws {
        let request = try buildRequest(from: router)
        task = session.dataTask(request: request, completionHandler: {[context, logger] data, response, error in

            if router.isDebug {
                logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }

            completion(data, response as? HTTPURLResponse, context, error)
        })
        resume()
    }

    public func response(_ router: EndPoint, completion: @escaping NetworkRouterResponseCompletion) throws {
        let request = try buildRequest(from: router)
        task = session.dataTask(request: request, completionHandler: {[context, logger] data, response, error in

            if router.isDebug {
                logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }

            let result = Response<Data>(with: router, urlResponse: response, context: context, data: data, dataObject: data)

            completion(result, error)
        })
        resume()
    }

    public func resume() {
        task?.resume()
    }

    public func cancel() {
        task?.cancel()
    }
}

extension NetworkRouter {
    
    public func jsonRequest<T: Codable>(_ router: EndPoint, completion: @escaping ((_ data: T?, _ response: HTTPURLResponse?, _ error: Error?) -> Swift.Void)) throws {
        let request = try buildRequest(from: router)
        
        task = session.dataTask(request: request) {[context, logger] data, response, error in
            
            if router.isDebug {
                logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }
            
            if let error = error {
                completion(nil, response as? HTTPURLResponse, error)
            } else if let data = data {
                let decoder = JSONDecoder()
                if let managedObjectContext = CodingUserInfoKey.managedObjectContext {
                    decoder.userInfo[managedObjectContext] = context
                }
                let element = try? decoder.decode(T.self, from: data)
                completion(element, response as? HTTPURLResponse, error)
            }
        }
        
        resume()
    }
    
    public func jsonResponse<T: Codable>(_ router: EndPoint, completion: @escaping ((Response<T>?, Error?) -> Swift.Void)) throws {
        let request = try buildRequest(from: router)
        task = session.dataTask(request: request) {[context, logger]  data, response, error in

            let result = Response<T>(with: router, urlResponse: response, context: context)
            
            if router.isDebug {
                logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }

            if let data = data {
                result.handleData(data: data, completion: { (data) -> T? in
                    guard let data = data else { return nil }
                    let decoder = JSONDecoder()
                    if let managedObjectContext = CodingUserInfoKey.managedObjectContext {
                        decoder.userInfo[managedObjectContext] = context
                    }
                    return try? decoder.decode(T.self, from: data)
                })
            }
            
            completion(result, error)
        }
        
        resume()
    }
    
    public func syncResponse<T: Codable>(_ router: EndPoint) throws -> (Response<T>?, Error?) {
        let request = try buildRequest(from: router)
        var result: (Response<T>?, Error?) = (nil, nil)
        task = session.sendSynchronousRequest(request: request) {[context, logger] data, response, error in
            let dataResponse = Response<T>(with: router, urlResponse: response, context: context)
            
            if router.isDebug {
                logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }
            
            if let data = data {
                dataResponse.handleData(data: data, completion: { (data) -> T? in
                    guard let data = data else { return nil }
                    let decoder = JSONDecoder()
                    if let managedObjectContext = CodingUserInfoKey.managedObjectContext {
                        decoder.userInfo[managedObjectContext] = context
                    }
                    return try? decoder.decode(T.self, from: data)
                })
            }
            
            result.0 = dataResponse
            result.1 = error
        }
        
        task?.resume()
        return result
    }
}

extension NetworkRouter {
    
    public func download(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) throws {
        let request = try buildRequest(from: router)
        task = session.dataTask(request: request, completionHandler: {[context,logger] data, response, error in
            
            if router.isDebug {
                logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }
            
            completion(data, response as? HTTPURLResponse, context, error)
        })
        resume()
    }
    
    public func download(_ url: URL, completion: @escaping NetworkRouterCompletion) {
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        task = session.dataTask(request: request, completionHandler: {[context] data, response, error in
            completion(data, response as? HTTPURLResponse, context, error)
        })
        resume()
    }
    
    public func upload(_ router: EndPoint, from: Data?, completion: @escaping NetworkRouterCompletion) throws {
        let request = try buildRequest(from: router)
        task = session.uploadTask(request: request, from: from, completionHandler: {[context,logger] data, response, error in
            
            if router.isDebug {
                logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }
            
            completion(data, response as? HTTPURLResponse, context, error)
        })
        resume()
    }
}
#endif
