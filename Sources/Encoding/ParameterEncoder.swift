//
//  Encoder.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public typealias Parameters = [String:Any]

public protocol ParameterEncoderProtocol {
    static func encoder(urlRequest: inout URLRequest, with parameters: Parameters?) throws
}

public enum ParameterEncoder {
    case urlEncoding
    case jsonEncoding
    
    public func encode(urlRequest: inout URLRequest, bodyParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try URLParameterEncoder.encoder(urlRequest: &urlRequest, with: bodyParameters)
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder.encoder(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}
