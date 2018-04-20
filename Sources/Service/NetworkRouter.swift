//
//  Router.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public class NetworkRouter<EndPoint: EndPointType>: NetworkRouterProtocol {
    private var task: URLSessionTask?
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.init())
    
    fileprivate var logger: NetworkLoggerProtocol?
    
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
    
    fileprivate func additionalHeaders(_ additionHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func appendingQueryParameters(_ parameters : Parameters?, request: inout URLRequest) {
        guard let parameters = parameters, !parameters.isEmpty else { return }
        guard let url = request.url else { return }
        let URLString : String = String(format: "%@?%@", url.absoluteString, parameters.queryParameters)
        request.url = URL(string: URLString)!
    }
    
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
