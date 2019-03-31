//
//  CacheService.swift
//  Request
//
//  Created by Amine Bensalah on 17/04/2018.
//

import Foundation

/// Cache Service Protocol
protocol CacheServiceProtocol {

    /// The Key object must be an AnyObject
    associatedtype Key: AnyObject
    /// The Value object must be an AnyObject
    associatedtype Value: AnyObject

    /**
     Add object with key in cache

     - Parameter key: The Key object
     - Parameter value: The Value object
     */
    func add(key: Key, value: Value)

    /**
     Get object with key in cache

     - Parameter key: The Key object

     - Returns: The value object or nil
     */
    func get(key: Key) -> Value?

    /**
     Replace object with key in cache

     - Parameter key: The Key object
     - Parameter value: The Value object

     - Returns: The old value Object or nil
     */
    func replace(key: Key, value: Value) -> Value?

    /**
     Remove object with key in cache

     - Parameter key: The Key object

     - Returns: The old value Object or nil
     */
    func remove(key: Key) -> Value?
}

/// Cache default service
public class CacheService<Key: AnyObject, Value: AnyObject>: CacheServiceProtocol {
    private let cache: NSCache<Key, Value>

    public init() {
        cache = NSCache<Key, Value>()
    }

    public func add(key: Key, value: Value) {
        cache.setObject(value, forKey: key)
    }

    public func get(key: Key) -> Value? {
        return cache.object(forKey: key)
    }

    /// Replace data
    /// returns Old data
    @discardableResult
    public func replace(key: Key, value: Value) -> Value? {
        let oldData = get(key: key)
        add(key: key, value: value)
        return oldData
    }

    @discardableResult
    public func remove(key: Key) -> Value? {
        let data = get(key: key)
        cache.removeObject(forKey: key)
        return data
    }
}

/// Downloader cache default service
public final class DownloadCacheService {
    /// Shared service object
    public static let shared = DownloadCacheService()

    /// Cache service
    private let cache = CacheService<NSString, NSData>()

    /**
     Add object with key in cache

     - Parameter key: The String Key
     - Parameter data: The Data object
     */
    public func add(key: String, data: Data) {
        cache.add(key: key as NSString, value: data as NSData)
    }

    /**
     Get object with key in cache

     - Parameter key: The String Key

     - Returns: The data object or nil
     */
    public func get(key: String) -> Data? {
        return cache.get(key: key as NSString) as Data?
    }

    /**
     Replace object with key in cache

     - Parameter key: The String Key
     - Parameter data: The data object

     - Returns: The old data Object or nil
     */
    public func replace(key: String, data: Data) -> Data? {
        return cache.replace(key: key as NSString, value: data as NSData) as Data?
    }

    /**
     Remove object with key in cache

     - Parameter key: The String Key

     - Returns: The old data Object or nil
     */
    public func remove(key: String) -> Data? {
        return cache.remove(key: key as NSString) as Data?
    }
}
