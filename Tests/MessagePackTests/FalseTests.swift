import Foundation
@testable import MessagePack
import XCTest

class FalseTests: XCTestCase {
  static var allTests = [
    ("testLiteralConversion", testLiteralConversion),
    ("testPack", testPack),
    ("testUnpack", testUnpack),
  ]

  let packed = Data([0xC2])

  func testLiteralConversion() {
    let implicitValue: MessagePackValue = false
    XCTAssertEqual(implicitValue, MessagePackValue.bool(false))
  }

  func testPack() {
    XCTAssertEqual(pack(.bool(false)), self.packed)
  }

  func testUnpack() {
    let unpacked = try? unpack(self.packed)
    XCTAssertEqual(unpacked?.value, .bool(false))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }
}
