//
//  PatternRouteMatcher.swift
//  SwiftTaylor
//
//  Created by Tran Thien Khiem on 17/6/18.
//

import Foundation

public struct PatternRouteMatcher: RouteMatcher {
    
    let method: Method
    let pattern: String
    
    public init(method: Method, pattern: String) {
        self.method = method
        self.pattern = pattern
    }
    
    /// Check if a route is matched
    ///
    /// - Parameter route: <#route description#>
    /// - Returns: <#return value description#>
    public func match(method: Method, route: String) -> RouteData? {
        return nil
    }
}
