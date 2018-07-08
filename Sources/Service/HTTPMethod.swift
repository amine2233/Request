//
//  HTTPMethod.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/**
 HTTP method type

 - get: GET method type for request
 - post: POST method type for request
 - put: PUT method type for request
 - patch: PATCH method type for request
 - delete: DELETE method type for request
 - head: HEAD method type for request
 */
public enum HttpMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
    case head = "HEAD"
}
