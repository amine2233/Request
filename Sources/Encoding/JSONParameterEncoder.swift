//
//  JSONParameterEncoder.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// JSON request encodeur
public struct JSONParameterEncoder: ParameterEncoderProtocol {
    /**
     Encoding body request

     - Parameter urlRequest: The URLRequest construct
     - Parameter bodyParameters: the parameters we will add in request for send

     - Throws: `NetworkError.parametersNil` parameters is nil when try to construct json body
     - Throws: `NetworkError.encodingFailed` failed encoding json
     */
    public static func encoder(urlRequest: inout URLRequest, with parameters: Parameters?) throws {
        do {
            guard let parameters = parameters else { throw NetworkError.parametersNil }
            let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            urlRequest.httpBody = jsonAsData
            if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
            }
        } catch {
            throw NetworkError.encodingFailed
        }
    }
}
