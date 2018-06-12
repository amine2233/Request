//
//  Router.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// The Network Router use it for request endpoint type
public class NetworkRouter<EndPoint: EndPointType>: NetworkRouterProtocol {    
    
    /// The url session task
    private var task: URLSessionDataTaskProtocol?
    
    /// The natif url session
    fileprivate var session: URLSessionProtocol
    
    /// The network logger
    private(set) public var logger: NetworkLoggerProtocol?
    
    /**
     The network router initializer
     
     - Parameter logger: The Network logger
     
     - Returns: The NetworkRouter Object
     */
    public init(session: URLSessionProtocol? = nil, logger: NetworkLoggerProtocol? = nil) {
        self.session = session ?? URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.init())
        self.logger = logger
    }
    
    public func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) throws {
        let request = try self.buildRequest(from: router)
        task = session.dataTask(request: request, completionHandler: { (data, response, error) in
            
            if router.isDebug {
                self.logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }
            
            completion(data, response as? HTTPURLResponse, error)
        })
        self.resume()
    }
    
    public func response(_ router: EndPoint, completion: @escaping NetworkRouterResponseCompletion) throws {
        let request = try self.buildRequest(from: router)
        task = session.dataTask(request: request, completionHandler: { (data, response, error) in
            
            let result = Response<Data>(with: router, urlResponse: response, data: data, dataObject: data)
            
            if router.isDebug {
                self.logger?.log(route: router, response: response as? HTTPURLResponse, info: result, error: error)
            }
            
            completion(result, error)
        })
        self.resume()
    }
    
    public func jsonRequest<T: Codable>(_ router: EndPoint, completion: @escaping ((_ data: T?, _ response: HTTPURLResponse?, _ error: Error?) -> Swift.Void)) throws {
        let request = try self.buildRequest(from: router)
        
        self.task = session.dataTask(request: request) { (data, response, error) in
            
            if router.isDebug {
                self.logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }
            
            if let error = error {
                completion(nil, response as? HTTPURLResponse, error)
            } else if let data = data {
                let element = try? JSONDecoder().decode(T.self, from: data)
                completion(element, response as? HTTPURLResponse, error)
            }
        }
        
        self.resume()
    }
    
    public func jsonResponse<T: Codable>(_ router: EndPoint, completion: @escaping ((Response<T>?, Error?) -> Swift.Void)) throws {
        let request = try self.buildRequest(from: router)
        
        self.task = session.dataTask(request: request) { (data, response, error) in
            
            var result = Response<T>(with: router, urlResponse: response)
            
            if let data = data {
                result.handleData(data: data, completion: { (data) -> T? in
                    guard let data = data else { return nil }
                    return try? JSONDecoder().decode(T.self, from: data)
                })
            }
            
            if router.isDebug {
                self.logger?.log(route: router, response: response as? HTTPURLResponse, info: result, error: error)
            }
            
            completion(result,error)
        }
        
        self.resume()
    }
    
    public func download(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) throws {
        let request = try self.buildRequest(from: router)
        task = session.dataTask(request: request, completionHandler: { (data, response, error) in
            
            if router.isDebug {
                self.logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }
            
            completion(data, response as? HTTPURLResponse, error)
        })
        self.resume()
    }
    
    public func download(_ url: URL, completion: @escaping NetworkRouterCompletion) {
        let request = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        task = session.dataTask(request: request, completionHandler: { (data, response, error) in
            completion(data, response as? HTTPURLResponse, error)
        })
        self.resume()
    }
    
    public func upload(_ router: EndPoint, from: Data?, completion: @escaping NetworkRouterCompletion) throws {
        let request = try self.buildRequest(from: router)
        task = session.uploadTask(request: request, from: from, completionHandler: { (data, response, error) in
            
            if router.isDebug {
                self.logger?.log(route: router, response: response as? HTTPURLResponse, data: data, error: error)
            }
            
            completion(data, response as? HTTPURLResponse, error)
        })
        self.resume()
    }
    
    public func syncResponse<T: Codable>(_ router: EndPoint) throws -> (Response<T>?, Error?) {
        let request = try self.buildRequest(from: router)
        var result: (Response<T>?, Error?) = (nil,nil)
        session.sendSynchronousRequest(request: request) { (data, response, error) in
            var dataResponse = Response<T>(with: router, urlResponse: response)
            
            if let data = data {
                dataResponse.handleData(data: data, completion: { (data) -> T? in
                    guard let data = data else { return nil }
                    return try? JSONDecoder().decode(T.self, from: data)
                })
            }
            
            if router.isDebug {
                self.logger?.log(route: router, response: response as? HTTPURLResponse, info: dataResponse, error: error)
            }
            
            result.0 = dataResponse
            result.1 = error
        }
        return result
    }
    
    public func resume() {
        self.task?.resume()
    }
    
    public func cancel() {
        self.task?.cancel()
    }
}
