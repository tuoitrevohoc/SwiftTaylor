//
//  PatternRouteMatcher.swift
//  SwiftTaylor
//
//  Created by Tran Thien Khiem on 17/6/18.
//

import Foundation

/// Simple pattern matcher
public struct PatternMatcher: Matcher {
    
    /// The method
    let method: Method
    
    /// the pattern
    let pattern: String
    
    /// the slash
    static let backSlash: Character = "/"
    
    /// Construct a pattern route matcher using a method and pattern
    ///
    /// - Parameters:
    ///   - method: the http request method
    ///   - pattern: the pattern
    public init(method: Method, pattern: String) {
        self.method = method
        self.pattern = pattern
    }
    
    
    /// Check if a route is match
    ///
    /// - Parameters:
    ///   - method: the method of the requets
    ///   - route: the route as string
    /// - Returns: the route data
    public func match(method: Method, path: String) -> RouteData? {
        if self.method == method {
            return match(path: path)
        }
        
        return nil
    }
    
    
    /// Match the route
    ///
    /// - Parameter path: the path to check
    /// - Returns: the value
    fileprivate func match(path: String) -> RouteData? {
        var result: RouteData? = nil
        var parameters = [String: String]()
        var patternIndex = pattern.startIndex
        let patternEndIndex = pattern.endIndex
        var pathIndex = path.startIndex
        let pathEndIndex = path.endIndex
        
        while patternIndex < patternEndIndex && pathIndex < pathEndIndex {
            let patternCharacter = pattern[patternIndex]
            patternIndex = pattern.index(after: patternIndex)
            
            switch patternCharacter {
            case ":":
                let nextPatternIndex = nextComponent(in: pattern,
                                                     fromIndex: patternIndex,
                                                     until: patternEndIndex)
                let nextPathIndex = nextComponent(in: path,
                                                   fromIndex: pathIndex,
                                                   until: pathEndIndex)
                
                let name = String(pattern[patternIndex...nextPatternIndex])
                let value = String(path[pathIndex...nextPathIndex])
                
                parameters[name] = value
                
                patternIndex = pattern.index(after: nextPatternIndex)
                pathIndex = path.index(after: nextPathIndex)
            default:
                if path[pathIndex] != patternCharacter {
                    break
                }
                
                pathIndex = path.index(after: pathIndex)
            }
        }
        
        if patternIndex == patternEndIndex && pathIndex == pathEndIndex {
            result = RouteData(route: pattern, parameters: parameters)
        }
        
        return result
    }
    
    /// get the next component
    ///
    /// - Parameters:
    ///   - string: string
    ///   - index: the index
    fileprivate func nextComponent(in string: String,
                                   fromIndex index: String.Index,
                                   until endIndex: String.Index) -> String.Index {
        var nextIndex = index
        
        while nextIndex < endIndex && string[nextIndex] != PatternMatcher.backSlash {
            nextIndex = string.index(after: nextIndex)
        }
        
        return string.index(before: nextIndex)
    }
}
