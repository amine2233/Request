//
//  Middleware.swift
//  Request
//
//  Created by Amine Bensalah on 17/04/2018.
//

import Foundation

public typealias Next = ( Any... ) -> Swift.Void

public typealias NetworkMiddleware = (EndPointType, @escaping Next) -> Swift.Void
