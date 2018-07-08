//
//  URLParameterEncoder.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// URL Encodeur for standart request
public struct URLParameterEncoder: ParameterEncoderProtocol {
    /**
     Encoding body request

     - Parameter urlRequest: The URLRequest construct
     - Parameter bodyParameters: the parameters we will add in request for send
     */
    public static func encoder(urlRequest: inout URLRequest, with parameters: Parameters?) throws {
        guard let url = urlRequest.url else { throw NetworkError.missingURL }
        guard let parameters = parameters else { throw NetworkError.parametersNil }

        if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), !parameters.isEmpty {
            urlComponents.queryItems = [URLQueryItem]()

            for (key, value) in parameters {
                let queryItem = URLQueryItem(name: key, value: "\(value)".addingPercentEncoding(withAllowedCharacters: .urlHostAllowed))
                urlComponents.queryItems?.append(queryItem)
            }

            urlRequest.url = urlComponents.url
        }

        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}
