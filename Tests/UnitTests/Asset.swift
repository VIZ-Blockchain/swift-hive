
import Foundation
@testable import VIZ
import XCTest

class AssetTest: XCTestCase {
    func testEncodable() {
        AssertEncodes(Asset(10, .viz), Data("10270000000000000356495a00000000"))
        AssertEncodes(Asset(123_456.789, .vests), Data("081a99be1c0000000656455354530000"))
        AssertEncodes(Asset(10, .viz), "10.000 VIZ")
        AssertEncodes(Asset(123_456.789, .vests), "123456.789000 VESTS")
    }

    func testProperties() {
        let mockAsset = Asset(0.001, .viz)
        XCTAssertEqual(mockAsset.description, "0.001 VIZ")
        XCTAssertEqual(mockAsset.amount, 1)
        XCTAssertEqual(mockAsset.symbol, Asset.Symbol.viz)
        XCTAssertEqual(mockAsset.resolvedAmount, 0.001)
    }

    func testEquateable() {
        let mockAsset1 = Asset(0.1, .viz)
        let mockAsset2 = Asset(0.1, .vests)
        let mockAsset3 = Asset(0.1, .viz)
        XCTAssertFalse(mockAsset1 == mockAsset2)
        XCTAssertTrue(mockAsset1 == mockAsset3)
    }

    func testDecodable() throws {
        AssertDecodes(string: "10.000 VIZ", Asset(10, .viz))
        AssertDecodes(string: "0.001 VIZ", Asset(0.001, .viz))
        AssertDecodes(string: "123456789.999999 VESTS", Asset(123_456_789.999999, .vests))
    }
}
