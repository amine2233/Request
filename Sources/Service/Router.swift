//
//  Router.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public class Router<EndPoint: EndPointType>: NetworkRouterProtocol {
    private var task: URLSessionTask?
    fileprivate let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.init())
    
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) {
        
        do {
            let request = try self.buildRequest(from: router)
            task = session.dataTask(with: request, completionHandler: completion)
        } catch {
            completion(nil, nil, error)
        }
        self.task?.resume()
    }
    
    func cancel() {
        self.task?.cancel()
    }
    
    fileprivate func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)
        
        switch route.task {
        case .request:
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        case .requestParameters(let bodyParameters, let bodyEncoding, let urlParameters):
            try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
        case .requestParametersAndHeaders(let bodyParameters, let bodyEncoding, let urlParameters, let additionHeaders):
            self.additionalHeaders(additionHeaders, request: &request)
            try self.configureParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: urlParameters, request: &request)
        }
        return request
    }
    
    fileprivate func configureParameters(bodyParameters: Parameters?, bodyEncoding: ParameterEncoder, urlParameters: Parameters?, request: inout URLRequest) throws {
        do {
            switch bodyEncoding {
            case .jsonEncoding:
                try JSONParameterEncoder.encoder(urlRequest: &request, with: bodyParameters)
            case .urlEncoding:
                try URLParameterEncoder.encoder(urlRequest: &request, with: urlParameters)
            case .urlAndJsonEncoding:
                try JSONParameterEncoder.encoder(urlRequest: &request, with: bodyParameters)
                try URLParameterEncoder.encoder(urlRequest: &request, with: urlParameters)
            }
        } catch {
            throw error
        }
    }
    
    fileprivate func additionalHeaders(_ additionHeaders: HTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
}
