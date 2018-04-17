//
//  NetworkLogger.swift
//  Request
//
//  Created by Amine Bensalah on 17/04/2018.
//

import Foundation

protocol NetworkLoggerProtocol {
    @discardableResult
    func log(route: EndPointType, request: URLRequest) -> Self
    @discardableResult
    func log(route: EndPointType, response: URLResponse) -> Self
    @discardableResult
    func log(route: EndPointType, response: HTTPURLResponse) -> Self
}

class NetworkLogger: NetworkLoggerProtocol {
    
    @discardableResult
    func log(route: EndPointType, request: URLRequest) -> Self {
        
        print("\n - - - - - - - - - - NetworkRoute: \(route.name) BEGIN - - - - - - - - - - \n")
        print("\n - - - - - - - - - - Detail: \(route.dubugDescription) - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  NetworkRoute: \(route.name) END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(NSString(data: body, encoding: String.Encoding.utf8.rawValue) ?? "")"
        }
        
        print(logOutput)
        
        return self
    }
    
    @discardableResult
    func log(route: EndPointType, response: URLResponse) -> Self {
        
        print("\n - - - - - - - - - - ResponseRoute: \(route.name) BEGIN - - - - - - - - - - \n")
        print("\n - - - - - - - - - - Detail: \(route.dubugDescription) - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  ResponseRoute: \(route.name) END - - - - - - - - - - \n") }
        
        let urlAsString = response.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        let logOutput = """
        \(urlAsString) \n\n
        \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        
        print(logOutput)
        
        return self
    }
    
    @discardableResult
    func log(route: EndPointType, response: HTTPURLResponse) -> Self {
        
        print("\n - - - - - - - - - - ResponseRoute: \(route.name) BEGIN - - - - - - - - - - \n")
        print("\n - - - - - - - - - - Detail: \(route.dubugDescription) - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  ResponseRoute: \(route.name) END - - - - - - - - - - \n") }
        
        let urlAsString = response.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        STATUS: \(response.statusCode)\n
        """
        for (key,value) in response.allHeaderFields {
            logOutput += "\(key): \(value) \n"
        }
        
        print(logOutput)
        
        return self
    }
}
