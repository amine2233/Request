//
//  NetworkLogger.swift
//  Request
//
//  Created by Amine Bensalah on 17/04/2018.
//

import Foundation

/// Network logger protocol
public protocol NetworkLoggerProtocol {
    /**
     Network logger request

     - Parameter route: The endpoint router
     - Parameter request: The url request

     - Returns: The NewtorkLoggerProtocol for chaining loging
     */
    @discardableResult
    func log(route: RequestProtocol, request: URLRequest) -> Self

    /**
     Network logger response

     - Parameter route: The endpoint router
     - Parameter response: The url response
     - Parameter error: The Error object

     - Returns: The NewtorkLoggerProtocol for chaining loging
     */
    @discardableResult
    func log(route: RequestProtocol, response: URLResponse?, data: Data?, error: Error?) -> Self

    /**
     Network logger url & body response

     - Parameter route: The endpoint router
     - Parameter response: The http url response
     - Parameter error: The Error object

     - Returns: The NewtorkLoggerProtocol for chaining loging
     */
    @discardableResult
    func log(route: RequestProtocol, response: HTTPURLResponse?, data: Data?, error: Error?) -> Self

    /**
     Network logger url & object response

     - Parameter route: The endpoint router
     - Parameter response: The http url response
     - Parameter info: The Response object with data information
     - Parameter error: The Error object

     - Returns: The NewtorkLoggerProtocol for chaining loging
     */
    @discardableResult
    func log<T: ResponseProtocol>(route: RequestProtocol, response: HTTPURLResponse?, info: T?, error: Error?) -> Self
}

/// The standard network logger
public final class NetworkLogger: NetworkLoggerProtocol {
    /// Initilise NetworkLogger
    public init() {}

    @discardableResult
    public func log(route: RequestProtocol, request: URLRequest) -> Self {
        print("\n******************* 🔥 BEGIN Request: \(route.name) *******************")
        print("- - - - - - - - - - Detail: \(route.dubugDescription) - - - - - - - - - -")
        defer { print("******************* 📦 END Request: \(route.name) *******************\n") }

        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        var logOutput = """
        [Request]\n
        URL: \(urlAsString)\n
        Host: \(host)\n
        Method: [\(method)] \(path)?\(query)\n
        Headers:\n\n
        """
        for (key, value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\t\(key): \(value)\n"
        }
        if let body = request.httpBody {
            logOutput += "HttpBody:\n\n\t\(body.toString ?? "Empty request body")\n"
        }

        print(logOutput)

        return self
    }

    @discardableResult
    public func log(route: RequestProtocol, response: URLResponse?, data: Data?, error: Error?) -> Self {
        print("******************* ✅ BEGIN Response: \(route.name) *******************")
        print("- - - - - - - - - - Detail: \(route.dubugDescription) - - - - - - - - - -")
        defer { print("******************* 📦 END Response: \(route.name) *******************\n") }

        guard let response = response else { return self }

        let urlAsString = response.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        var logOutput = """
        [Response]:\n
        URL: \(urlAsString)\n
        Method: [\(route.httpMethod.rawValue)] \(path)?\(query)\n
        Host: \(host)\n
        """
        if let error = error {
            logOutput += "\nError: \(error.localizedDescription)"
        }

        print(logOutput)

        if let data = data {
            print("data:\n\n", data.toString ?? "")
        }

        return self
    }

    @discardableResult
    public func log(route: RequestProtocol, response: HTTPURLResponse?, data: Data?, error: Error?) -> Self {
        print("\n******************* ✅ BEGIN Response: \(route.name) *******************")
        print("- - - - - - - - - - Detail: \(route.dubugDescription) - - - - - - - - - -")
        defer { print("******************* 📦 END Response: \(route.name) [\(response?.statusCode ?? 0)] *******************\n") }

        guard let response = response else { return self }

        let urlAsString = response.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        var logOutput = """
        [Response]:\n
        URL: \(urlAsString)\n
        Method: [\(route.httpMethod.rawValue)] \(path)?\(query)\n
        Host: \(host)\n
        StatusCode: [\(StatusCode(statusCode: response.statusCode).emoji)] \(response.statusCode)\n
        Info: \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))\n
        Headers:\n\n
        """
        for (key, value) in response.allHeaderFields {
            logOutput += "\t\(key): \(value)\n"
        }

        if let error = error {
            logOutput += "\nError: \(error.localizedDescription)"
        }

        print(logOutput)

        if let data = data {
            print("data:\n\n", data.toString ?? "")
        }

        return self
    }

    public func log<T: ResponseProtocol>(route: RequestProtocol, response: HTTPURLResponse?, info: T?, error: Error?) -> Self {
        print("\n******************* ✅ BEGIN Response: \(route.name) *******************")
        print("- - - - - - - - - - Detail: \(route.dubugDescription) - - - - - - - - - -")
        defer { print("******************* 📦 END Response: \(route.name) [\(response?.statusCode ?? 0)] *******************\n") }

        guard let response = response else { return self }

        let urlAsString = response.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)

        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"

        var logOutput = """
        [Response]:\n
        URL: \(urlAsString)\n
        Method: [\(route.httpMethod.rawValue)] \(path)?\(query)\n
        Host: \(host)\n
        StatusCode: [\(StatusCode(statusCode: response.statusCode).emoji)] \(response.statusCode)\n
        Info: \(HTTPURLResponse.localizedString(forStatusCode: response.statusCode))\n
        Headers:\n\n
        """

        for (key, value) in response.allHeaderFields {
            logOutput += "\t\(key): \(value)\n"
        }

        if let error = error {
            logOutput += "\nError: \(error.localizedDescription)"
        }

        print(logOutput)

        if let data = info?.data, let json = data.toString {
            print("data:\n\n", json)
        }

        return self
    }
}
