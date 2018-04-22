//
//  HTTPTask.swift
//  Request
//
//  Created by Amine Bensalah on 16/04/2018.
//

import Foundation

/// HTTPHeaders dictionary type with string key and string value 
public typealias HTTPHeaders = [String:String]

/**
 HTTP task type
 
 - request: Request type task
 - download: Download type task
 - upload: Upload type task with data we will upload
 */
public enum HTTPTask {
    case request
    case download
    case upload(from: Data?)
}
