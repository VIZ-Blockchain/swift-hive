import XCTest

import UnitTests
import IntegrationTests

var tests = [XCTestCaseEntry]()
tests += UnitTests.allTests()
tests += IntegrationTests.allTests()
XCTMain(tests)
