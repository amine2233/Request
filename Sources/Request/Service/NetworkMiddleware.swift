//
//  Middleware.swift
//  Request
//
//  Created by Amine Bensalah on 17/04/2018.
//

import Foundation

/// The next action
public typealias Next = (Any...) -> Swift.Void

/// The network Middleware
public typealias NetworkMiddleware = (EndPointType, @escaping NetworkRouterCompletion, @escaping Next) -> Swift.Void
