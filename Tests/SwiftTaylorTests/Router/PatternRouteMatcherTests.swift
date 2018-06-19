//
//  RouteMatcherTests.swift
//  SwiftTaylorTests
//
//  Created by Tran Thien Khiem on 17/6/18.
//

import XCTest
import SwiftTaylor

class PatternRouteMatcherTests: XCTestCase {
    
    func testMatch_ExactRoute() {
        let matcher = PatternRouteMatcher(method: Method.GET, pattern: "/path")
        let result = matcher.match(method: Method.GET, route: "/path")
        XCTAssertNotNil(result)
        XCTAssertEqual("/path", result?.path)
        XCTAssertEqual(0, result?.parameters.count)
    }
    
    func testMatch_Pattern() {
        let matcher = PatternRouteMatcher(method: Method.GET, pattern: "/path/:id")
        let result = matcher.match(method: Method.GET, route: "/path/12")
        XCTAssertNotNil(result)
        XCTAssertEqual("/path/:id", result?.path)
        XCTAssertEqual(1, result?.parameters.count)
        XCTAssertEqual("12", result?.parameters["id"] as? String)
    }
    
    func testMatch_Pattern_withExtra() {
        let matcher = PatternRouteMatcher(method: Method.GET, pattern: "/path/:id/concepts")
        let result = matcher.match(method: Method.GET, route: "/path/12/concepts")
        XCTAssertNotNil(result)
        XCTAssertEqual("/path/:id/concepts", result?.path)
        XCTAssertEqual(1, result?.parameters.count)
        XCTAssertEqual("12", result?.parameters["id"] as? String)
    }
    
    func testMatch_Pattern_withTwoParameters() {
        let matcher = PatternRouteMatcher(method: Method.GET, pattern: "/path/:id/:items")
        let result = matcher.match(method: Method.GET, route: "/path/12/concepts")
        XCTAssertNotNil(result)
        XCTAssertEqual("/path/:id/concepts", result?.path)
        XCTAssertEqual(2, result?.parameters.count)
        XCTAssertEqual("12", result?.parameters["id"] as? String)
        XCTAssertEqual("concepts", result?.parameters["items"] as? String)
    }
    
    func testNotMatch() {
        let matcher = PatternRouteMatcher(method: Method.GET, pattern: "/path")
        let result = matcher.match(method: Method.GET, route: "/otherpath")
        XCTAssertNil(result)
    }

    func testNotMatchExtended() {
        let matcher = PatternRouteMatcher(method: Method.GET, pattern: "/path")
        let result = matcher.match(method: Method.GET, route: "/paths")
        XCTAssertNil(result)
    }
    
    func testNotMatchExtended2() {
        let matcher = PatternRouteMatcher(method: Method.GET, pattern: "/path")
        let result = matcher.match(method: Method.GET, route: "/path/subpath")
        XCTAssertNil(result)
    }

}
