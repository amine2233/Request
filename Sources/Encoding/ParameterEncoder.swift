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
    case urlAndJsonEncoding
    
    public func encode(urlRequest: inout URLRequest, bodyParameters: Parameters?, urlParameters: Parameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder.encoder(urlRequest: &urlRequest, with: urlParameters)
            case .jsonEncoding:
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder.encoder(urlRequest: &urlRequest, with: bodyParameters)
            case .urlAndJsonEncoding:
                guard let urlParameters = urlParameters, let bodyParameters = bodyParameters else { return }
                try URLParameterEncoder.encoder(urlRequest: &urlRequest, with: urlParameters)
                try JSONParameterEncoder.encoder(urlRequest: &urlRequest, with: bodyParameters)
            }
        } catch {
            throw error
        }
    }
}
