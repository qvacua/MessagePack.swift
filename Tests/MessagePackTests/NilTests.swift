import Foundation
@testable import MessagePack
import XCTest

class NilTests: XCTestCase {
  static var allTests = [
    ("testLiteralConversion", testLiteralConversion),
    ("testPack", testPack),
    ("testUnpack", testUnpack),
  ]

  let packed = Data([0xC0])

  func testLiteralConversion() {
    let implicitValue: MessagePackValue = nil
    XCTAssertEqual(implicitValue, MessagePackValue.nil)
  }

  func testPack() {
    XCTAssertEqual(pack(.nil), self.packed)
  }

  func testUnpack() {
    let unpacked = try? unpack(self.packed)
    XCTAssertEqual(unpacked?.value, MessagePackValue.nil)
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }
}
