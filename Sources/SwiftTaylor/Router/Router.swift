//
//  Router.swift
//  SwiftTaylor
//
//  Created by visa on 21/6/18.
//

import Foundation

/// The router handler
public struct RouteHandler {
    let matcher: Matcher
    let handler: Handler
}

fileprivate let ParameterKey = "parameters"

/// The simple router
public struct Router {

    /// the handler
    var routes: [RouteHandler] = []
    
    /// Initialize a router
    public init() {
    }
    
    /// Add a route handler
    ///
    /// - Parameter handler: the route handler
    mutating public func add(route: RouteHandler) {
        routes.append(route)
    }
    
    /// Handle the next request
    ///
    /// - Parameters:
    ///   - request: the request
    ///   - response: the response
    ///   - next: the next function
    public func handle(request: Request, response: Response, next: Next) {
        var matched = false
        
        for route in routes {
            if let data = route.matcher.match(method: request.method, path: request.path) {
                request.data[ParameterKey] = data.parameters
                route.handler(request, response)
                matched = true
                break
            }
        }
        
        if !matched {
            next()
        }
    }
}

// MARK: - Extension on the server that adapt the router
extension Server {
    
    /// Use the router as a middleware
    ///
    /// - Parameter router: the router
    public func use(router: Router) {
        use(handler: router.handle)
    }
}

// MARK: - Add parameters to the request
extension Request {
    
    /// get parameters
    public var parameters: [String: String] {
        return data[ParameterKey] as? [String: String] ?? [:]
    }
}

// MARK: - extension
extension Router {
    
    /// add a new get route handler
    ///
    /// - Parameters:
    ///   - route: the route
    ///   - handler: the handler
    public mutating func get(_ pattern: String, handler: @escaping Handler) {
        add(route:
            RouteHandler(matcher: PatternMatcher(method: .GET, pattern: pattern),
                         handler: handler)
        )
    }
    
    /// add a new post route handler
    ///
    /// - Parameters:
    ///   - route: the route
    ///   - handler: the handler
    public mutating func post(_ pattern: String, handler: @escaping Handler) {
        add(route:
            RouteHandler(matcher: PatternMatcher(method: .POST, pattern: pattern),
                         handler: handler)
        )
    }
    
    /// add a new put route handler
    ///
    /// - Parameters:
    ///   - route: the route
    ///   - handler: the handler
    public mutating func put(_ pattern: String, handler: @escaping Handler) {
        add(route:
            RouteHandler(matcher: PatternMatcher(method: .PUT, pattern: pattern),
                         handler: handler)
        )
    }
    
    /// add a new patch route handler
    ///
    /// - Parameters:
    ///   - route: the route
    ///   - handler: the handler
    public mutating func patch(_ pattern: String, handler: @escaping Handler) {
        add(route:
            RouteHandler(matcher: PatternMatcher(method: .PATCH, pattern: pattern),
                         handler: handler)
        )
    }
    
    /// add a new delete route handler
    ///
    /// - Parameters:
    ///   - route: the route
    ///   - handler: the handler
    public mutating func delete(_ pattern: String, handler: @escaping Handler) {
        add(route:
            RouteHandler(matcher: PatternMatcher(method: .DELETE, pattern: pattern),
                         handler: handler)
        )
    }
}
