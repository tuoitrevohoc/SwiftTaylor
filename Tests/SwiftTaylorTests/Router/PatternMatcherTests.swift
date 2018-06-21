//
//  RouteMatcherTests.swift
//  SwiftTaylorTests
//
//  Created by Tran Thien Khiem on 17/6/18.
//

import XCTest
import SwiftTaylor

class PatternMatcherTests: XCTestCase {
    
    func testMatch_ExactRoute() {
        let matcher = PatternMatcher(method: Method.GET, pattern: "/path")
        let result = matcher.match(method: Method.GET, path: "/path")
        XCTAssertNotNil(result)
        XCTAssertEqual("/path", result?.route)
        XCTAssertEqual(0, result?.parameters.count)
    }
    
    func testMatch_Pattern() {
        let matcher = PatternMatcher(method: Method.GET, pattern: "/path/:id")
        let result = matcher.match(method: Method.GET, path: "/path/12")
        XCTAssertNotNil(result)
        XCTAssertEqual("/path/:id", result?.route)
        XCTAssertEqual(1, result?.parameters.count)
        XCTAssertEqual("12", result?.parameters["id"])
    }
    
    func testMatch_Pattern_withExtra() {
        let matcher = PatternMatcher(method: Method.GET, pattern: "/path/:id/concepts")
        let result = matcher.match(method: Method.GET, path: "/path/12/concepts")
        XCTAssertNotNil(result)
        XCTAssertEqual("/path/:id/concepts", result?.route)
        XCTAssertEqual(1, result?.parameters.count)
        XCTAssertEqual("12", result?.parameters["id"])
    }
    
    func testMatch_Pattern_withTwoParameters() {
        let matcher = PatternMatcher(method: Method.GET, pattern: "/path/:id/:items")
        let result = matcher.match(method: Method.GET, path: "/path/12/concepts")
        XCTAssertNotNil(result)
        XCTAssertEqual("/path/:id/:items", result?.route)
        XCTAssertEqual(2, result?.parameters.count)
        XCTAssertEqual("12", result?.parameters["id"])
        XCTAssertEqual("concepts", result?.parameters["items"])
    }
    
    func testNotMatch() {
        let matcher = PatternMatcher(method: Method.GET, pattern: "/path")
        let result = matcher.match(method: Method.GET, path: "/otherpath")
        XCTAssertNil(result)
    }

    func testNotMatchExtended() {
        let matcher = PatternMatcher(method: Method.GET, pattern: "/path")
        let result = matcher.match(method: Method.GET, path: "/paths")
        XCTAssertNil(result)
    }
    
    func testNotMatchExtended2() {
        let matcher = PatternMatcher(method: Method.GET, pattern: "/path")
        let result = matcher.match(method: Method.GET, path: "/path/subpath")
        XCTAssertNil(result)
    }

}
