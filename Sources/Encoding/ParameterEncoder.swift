//
//  Encoder.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// Request Parameters for query and body request
public typealias Parameters = [String:Any]

/// Parameter Encoder Protocol for encode body in request
public protocol ParameterEncoderProtocol {
    static func encoder(urlRequest: inout URLRequest, with parameters: Parameters?) throws
}

/**
 Network error for construct request
 
 - urlEncoding: Data url encoding type
 - jsonEncoding: Data json encoding type
 */
public enum ParameterEncoder {
    case urlEncoding
    case jsonEncoding
    
    /**
     Encoding body request
     
     - Parameter urlRequest: The URLRequest construct
     - Parameter bodyParameters: the parameters we will add in request for send
     */
    public func encode(urlRequest: inout URLRequest, bodyParameters: Parameters?) throws {
        guard let bodyParameters = bodyParameters else { return }
        
        do {
            switch self {
            case .urlEncoding:
                try URLParameterEncoder.encoder(urlRequest: &urlRequest, with: bodyParameters)
            case .jsonEncoding:
                try JSONParameterEncoder.encoder(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}
