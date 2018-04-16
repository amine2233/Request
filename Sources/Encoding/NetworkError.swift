//
//  NetworkError.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

public enum NetworkError: String, Error {
    case parametersNil = "Parameters were nil."
    case encodingFailed = "Paramter encoding failed."
    case missingURL = "URL is nil."
}
