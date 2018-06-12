//
//  NetworkMock.swift
//  Request
//
//  Created by Amine Bensalah on 10/06/2018.
//

import Foundation
import Request

class MockURLSessionDataTask: URLSessionDataTaskProtocol {
    private(set) var resumeWasCalled = false
    private(set) var wasCalled = false
    
    func resume() {
        resumeWasCalled = true
    }
    
    func cancel() {
        resumeWasCalled = true
        wasCalled = true
    }
}

class MockURLSession: URLSessionProtocol {
    
    var nextDataTask = MockURLSessionDataTask()
    var nextData: Data?
    var nextError: Error?
    
    private (set) var lastURL: URL?
    private (set) var lestData: Data?
    
    func successHttpURLResponse(request: URLRequest) -> URLResponse {
        return HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "HTTP/1.1", headerFields: nil)!
    }
    
    func dataTask(request: URLRequest, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
    
    func uploadTask(request: URLRequest, from bodyData: Data?, completionHandler: @escaping NetworkCompletion) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        lestData = bodyData
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
    
    func sendSynchronousRequest(request: URLRequest, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTaskProtocol {
        lastURL = request.url
        completionHandler(nextData, successHttpURLResponse(request: request), nextError)
        return nextDataTask
    }
}
