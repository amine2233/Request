//
//  NetworkRouter.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// Network Router completion for response request
public typealias NetworkRouterCompletion = (Data?, HTTPURLResponse?, CoreDataContextProtocol?, Error?) -> Swift.Void
public typealias NetworkRouterResponseCompletion = (Response<Data>?, Error?) -> Swift.Void

/// Network router protocol, must all network router implement this protocol
public protocol NetworkRouterProtocol {
    /// Endpoint type
    associatedtype EndPoint: EndPointType

    /// Logger protocol to personalize request & response log
    var logger: NetworkLoggerProtocol? { get }

    /**
     Request method

     - Parameter router: The endpoint we will use for request
     - Parameter completion: completion for request method to get server response
     */
    func request(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) throws

    /**
     Response request method

     - Parameter router: The endpoint we will use for request
     - Parameter completion: completion for request method to get server response
     */
    func response(_ router: EndPoint, completion: @escaping NetworkRouterResponseCompletion) throws

    /**
     Json request method

     - Parameter router: The endpoint we will use for request
     - Parameter type: The Codable type we will recive
     - Parameter completion: completion for request method to get server response
     */
    func jsonRequest<T: Codable>(_ router: EndPoint, completion: @escaping ((_ data: T?, _ response: HTTPURLResponse?, _ error: Error?) -> Swift.Void)) throws

    /**
     New json request method with response object

     - Parameter router: The endpoint we will use for request
     - Parameter type: The Codable type we will recive
     - Parameter completion: completion for request method to get server response
     */
    func jsonResponse<T: Codable>(_ router: EndPoint, completion: @escaping ((Response<T>?, Error?) -> Swift.Void)) throws

    /**
     Download method

     - Parameter router: The endpoint we will use for download data
     - Parameter completion: completion for request method to get server response
     */
    func download(_ router: EndPoint, completion: @escaping NetworkRouterCompletion) throws

    /**
     Download method with url

     - Parameter url: The url for download data
     - Parameter completion: completion for request method to get server response
     */
    func download(_ url: URL, completion: @escaping NetworkRouterCompletion) throws

    /**
     Request method to upload data

     - Parameter router: The endpoint we will use for upload data
     - Parameter from: The data we will upload to server
     - Parameter completion: completion for request method to get server response
     */
    func upload(_ router: EndPoint, from: Data?, completion: @escaping NetworkRouterCompletion) throws

    /**
     Sync response request method

     - Parameter router: The endpoint we will use for request
     - Returns tuples: Response and Error for request
     */
    func syncResponse<T: Codable>(_ router: EndPoint) throws -> (Response<T>?, Error?)

    /// Resume request task
    func resume()

    /// Cancel request task
    func cancel()
}

extension NetworkRouterProtocol {
    /**
     Build the request with endpoint

     - Parameter from: The endpoint we will use for request

     - Throws: `NetworkError.parametersNil` parameters is nil when try to construct json body
     - Throws: `NetworkError.encodingFailed` failed encoding json
     - Throws: `NetworkError.missingURL` can't build url
     */
    internal func buildRequest(from route: EndPoint) throws -> URLRequest {
        var request = URLRequest(url: route.baseURL.appendingPathComponent(route.path), cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 10.0)

        request.setValue("application/\(route.format)", forHTTPHeaderField: "Content-Type")
        additionalUrlParameters(route.urlParameters, request: &request)
        appendingQueryParameters(route.queriesParameters, request: &request)
        additionalHeaders(route.headers, request: &request)

        request.httpMethod = route.httpMethod.rawValue

        switch route.httpMethod {
        case .get, .head, .delete:
            break
        case .put, .post, .patch:
            try route.encoder?.encode(urlRequest: &request, bodyParameters: route.bodyParameters)
        }

        if route.isDebug {
            logger?.log(route: route, request: request)
        }

        return request
    }

    /**
     Add additional headers parameters

     - Parameter additionHeaders: The header parameters for this request
     - Parameter request: The url request
     */
    internal func additionalHeaders(_ additionHeaders: HTTPHeaders?, request: inout URLRequest) {
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
    internal func appendingQueryParameters(_ parameters: Parameters?, request: inout URLRequest) {
        guard let parameters = parameters, !parameters.isEmpty else { return }
        guard let url = request.url else { return }
        let URLString: String = String(format: "%@?%@", url.absoluteString, parameters.queryParameters)
        request.url = URL(string: URLString)!
    }

    /**
     Add url parameters

     - Parameter urlParameters: The url parameters for this request
     - Parameter request: The url request
     */
    internal func additionalUrlParameters(_ urlParameters: Parameters?, request: inout URLRequest) {
        guard let parameters = urlParameters, !parameters.isEmpty else { return }
        guard let url = request.url else { return }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }

            request.url = urlComponents.url
        }
    }
}
