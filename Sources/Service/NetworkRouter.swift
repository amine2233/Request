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
    private var task: URLSessionTask?
    
    /// The natif url session
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.init())
    
    /// The network logger
    fileprivate var logger: NetworkLoggerProtocol?
    
    /**
     The network router initializer
     
     - Parameter logger: The Network logger
     
     - Returns: The NetworkRouter Object
    */
    public init(logger: NetworkLoggerProtocol? = nil) {
        self.logger = logger
    }
    
    public func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) {
        do {
            let request = try self.buildRequest(from: router)
            task = session.dataTask(with: request, completionHandler: completion)
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    public func jsonRequest<T: Codable>(_ router: EndPoint, _ type: T.Type, completion: @escaping ((_ data: T?, _ response: URLResponse?, _ error: Error?) -> Swift.Void)) {
        
        do {
            let request = try self.buildRequest(from: router)
            
            self.task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    completion(nil, response, error)
                } else if let data = data {
                    let element = try? JSONDecoder().decode(type, from: data)
                    completion(element, response, error)
                }
            }
            
            self.task?.resume()
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    public func download(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) {
        do {
            let request = try self.buildRequest(from: router)
            task = session.dataTask(with: request, completionHandler: completion)
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    public func download(_ url: URL, completion: @escaping NetworkRouterCompletion) {
        let request = URLRequest.init(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        task = session.dataTask(with: request, completionHandler: completion)
        self.task?.resume()
    }
    
    public func upload(_ router: EndPoint, from: Data?, completion: @escaping NetworkRouterCompletion) {
        do {
            let request = try self.buildRequest(from: router)
            task = session.uploadTask(with: request, from: from, completionHandler: completion)
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    public func cancel() {
        self.task?.cancel()
    }
    
    /**
     Build the request with endpoint
     
     - Parameter from: The endpoint we will use for request
     
     - Throws: `NetworkError.parametersNil` parameters is nil when try to construct json body
     - Throws: `NetworkError.encodingFailed` failed encoding json
     - Throws: `NetworkError.missingURL` can't build url
     */
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
        request.setValue("application/\(route.format)", forHTTPHeaderField: "Content-Type")
        self.additionalUrlParameters(route.urlParameters, request: &request)
        self.appendingQueryParameters(route.queriesParameters, request: &request)
        
        switch route.httpMethod {
        case .get, .head, .delete:
            break
        case .put, .post, .patch:
            try route.encoder?.encode(urlRequest: &request, bodyParameters: route.bodyParameters)
        }
        
        if route.isDebug {
            self.logger?.log(route: route, request: request)
        }
        
        return request
    }
    
    /**
     Add additional headers parameters
     
     - Parameter additionHeaders: The header parameters for this request
     - Parameter request: The url request
     */
    fileprivate func additionalHeaders(_ additionHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    /**
     Add query parameters
     
     - Parameter parameters: The query parameters for this request
     - Parameter request: The url request
     */
    fileprivate func appendingQueryParameters(_ parameters : Parameters?, request: inout URLRequest) {
        guard let parameters = parameters, !parameters.isEmpty else { return }
        guard let url = request.url else { return }
        let URLString : String = String(format: "%@?%@", url.absoluteString, parameters.queryParameters)
        request.url = URL(string: URLString)!
    }
    
    /**
     Add url parameters
     
     - Parameter urlParameters: The url parameters for this request
     - Parameter request: The url request
     */
    fileprivate func additionalUrlParameters(_ urlParameters: Parameters?, request: inout URLRequest) {
        
        guard let parameters = urlParameters, !parameters.isEmpty else { return }
        guard let url = request.url else { return }
        
        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()
            
            for (key,value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }
            
            request.url = urlComponents.url
        }
    }
}
