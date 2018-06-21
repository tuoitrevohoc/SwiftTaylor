//
//  RouteMatcher.swift
//  SwiftTaylor
//
//  Created by Tran Thien Khiem on 15/6/18.
//

import Foundation

/// The route data
public struct RouteData {
    
    /// The route
    public var route: String
    
    /// parameters
    public var parameters: [String: String]
}

/// The route matcher
public protocol Matcher {
    
    /// Router matcher
    ///
    /// - Parameter route: the route to check
    /// - Returns: true if route is matching
    func match(method: Method, path: String) -> RouteData?
}
