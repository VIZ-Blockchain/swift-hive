import Foundation
import XCTest
@testable import VIZ

class ChainIdTest: XCTestCase {
    func testEncodeCustomChainId() {
        let mockChainId = ChainId(string: "11223344")
        XCTAssertEqual(mockChainId, ChainId.custom(Data(hexEncoded: "11223344")))
    }
    func testTestnetId() {
        let mockChainId = ChainId.testNet.data
        XCTAssertEqual(mockChainId, Data(hexEncoded: "46d82ab7d8db682eb1959aed0ada039a6d49afa1602491f93dde9cac3e8e6c32"))
    }
    func testMainnetId() {
        let mockChainId = ChainId.mainNet.data
        XCTAssertEqual(mockChainId, Data(hexEncoded: "2040effda178d4fffff5eab7a915d4019879f5205cc5392e4bcced2b6edda0cd"))
    }
}
