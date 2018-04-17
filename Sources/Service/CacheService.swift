//
//  CacheService.swift
//  Request
//
//  Created by Amine Bensalah on 17/04/2018.
//

import Foundation

protocol CacheServiceProtocol {
    associatedtype Key: AnyObject
    associatedtype Object: AnyObject
    func add(key: Key, data: Object)
    func get(key: Key) -> Object?
    func replace(key: Key, data: Object) -> Object?
    func remove(key: Key) -> Object?
}

class CacheService<Key:AnyObject,Object:AnyObject>: CacheServiceProtocol {
    
    private let cache: NSCache<Key,Object>
    
    init() {
        self.cache = NSCache<Key,Object>()
    }
    
    func add(key: Key, data: Object) {
        self.cache.setObject(data, forKey: key)
    }
    
    func get(key: Key) -> Object? {
        return self.cache.object(forKey: key)
    }
    
    /// Replace data
    /// returns Old data
    @discardableResult
    func replace(key: Key, data: Object) -> Object? {
        let oldData = self.get(key: key)
        self.add(key: key, data: data)
        return oldData
    }
    
    @discardableResult
    func remove(key: Key) -> Object? {
        let data = self.get(key: key)
        self.cache.removeObject(forKey: key)
        return data
    }
}

class DownloadCacheService {
    static let shared = DownloadCacheService()
    private let cache = CacheService<NSString,NSData>()
    
    func add(key: String, data: Data) {
        self.cache.add(key: key as NSString, data: data as NSData)
    }
    func get(key: String) -> Data? {
        return self.cache.get(key: key as NSString) as Data?
    }
    func replace(key: String, data: Data) -> Data? {
        return self.cache.replace(key: key as NSString, data: data as NSData) as Data?
    }
    func remove(key: String) -> Data? {
        return self.cache.remove(key: key as NSString) as Data?
    }
}
