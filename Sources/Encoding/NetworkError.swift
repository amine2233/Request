//
//  NetworkError.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/**
 Network error for construct request
 
 - parametersNil: Error when parameters is nil
 - encodingFailed: Error when failed encoding
 - missingURL: Error when url is nil
 */
public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Paramter encoding failed."
    case missingURL = "URL is nil."
}
