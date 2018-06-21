//
//  RouteMatcher.swift
//  SwiftTaylor
//
//  Created by Tran Thien Khiem on 15/6/18.
//

import Foundation

public struct RouteData {
    public var route: String
    public var parameters: [String: String]
}

/// The route matcher
public protocol RouteMatcher {
    
    /// Router matcher
    ///
    /// - Parameter route: the route to check
    /// - Returns: true if route is matching
    func match(method: Method, path: String) -> RouteData?
}
