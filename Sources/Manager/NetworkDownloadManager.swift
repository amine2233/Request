//
//  NetworkDownloadManager.swift
//  Request iOS
//
//  Created by Amine Bensalah on 19/04/2018.
//

import Foundation

final public class NetworkDownloadManager {
    
    var urlSession : URLSession
    
    static let shared = NetworkDownloadManager()
    
    init(urlSession: URLSession = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.init())) {
        self.urlSession = urlSession
    }
    
    public func download(url: String, completion: @escaping NetworkRouterCompletion) {
        guard let url = URL(string: url) else {
            completion(nil,nil,nil)
            return
        }
        
        let task = self.urlSession.dataTask(with: url, completionHandler: completion)
        task .resume()
    }
}
