//
//  JSONParameterEncoder.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public struct JSONParameterEncoder: ParameterEncoderProtocol {
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
