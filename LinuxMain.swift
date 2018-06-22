import XCTest
@testable import SwiftTaylorTests

#if !os(macOS)
var tests = [XCTestCaseEntry]()
tests += SwiftTaylorTests.allTests()
XCTMain(tests)
#endif
