//
//  URLSessionProtocol.swift
//  Request
//
//  Created by Amine Bensalah on 10/06/2018.
//

import Foundation

/// CoreData Context Protocol
public protocol CoreDataContextProtocol {
    func reset()
    
    func save() throws
}

/// URL Session Data Task Protocol
public protocol URLSessionDataTaskProtocol {
    func resume()

    func cancel()
}

/// The typealias for request response
public typealias NetworkCompletion = (Data?, URLResponse?, Error?) -> Void

/// The URL Session Protocol
public protocol URLSessionProtocol {
    /*
     * data task convenience methods.  These methods create tasks that
     * bypass the normal delegate calls for response and data delivery,
     * and provide a simple cancelable asynchronous interface to receiving
     * data.  Errors will be returned in the NSURLErrorDomain,
     * see <Foundation/NSURLError.h>.  The delegate, if any, will still be
     * called for authentication challenges.
     * return URLSessionDataTask
     */
    func dataTask(request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTaskProtocol

    /*
     * upload convenience method.
     * return URLSessionUploadTask
     */
    func uploadTask(request: URLRequest, from bodyData: Data?, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTaskProtocol

    /*
     * Send asynchronous request
     *
     */
    func sendSynchronousRequest(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol
}

extension URLSessionDataTask: URLSessionDataTaskProtocol {}

extension URLSession: URLSessionProtocol {
    public func dataTask(request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTaskProtocol {
        return dataTask(with: request, completionHandler: completionHandler) as URLSessionDataTaskProtocol
    }

    public func uploadTask(request: URLRequest, from bodyData: Data?, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTaskProtocol {
        return uploadTask(with: request, from: bodyData, completionHandler: completionHandler)
    }
}

/// Extension of the NSURLSession that blocks the data task with semaphore, so we can perform
/// a sync request.
extension URLSession {
    public func sendSynchronousRequest(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        let semaphore = DispatchSemaphore(value: 0)
        let task = dataTask(with: request) { data, response, error in
            completionHandler(data, response, error)
            semaphore.signal()
        }
        semaphore.wait()
        return task
    }
}
