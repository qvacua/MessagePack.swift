import Foundation
@testable import MessagePack
import XCTest

class DoubleTests: XCTestCase {
  static var allTests = [
    ("testLiteralConversion", testLiteralConversion),
    ("testPack", testPack),
    ("testUnpack", testUnpack),
  ]

  func testLiteralConversion() {
    let implicitValue: MessagePackValue = 3.14
    XCTAssertEqual(implicitValue, MessagePackValue.double(3.14))
  }

  let packed = Data([0xCB, 0x40, 0x09, 0x1E, 0xB8, 0x51, 0xEB, 0x85, 0x1F])

  func testPack() {
    XCTAssertEqual(pack(.double(3.14)), self.packed)
  }

  func testUnpack() {
    let unpacked = try? unpack(self.packed)
    XCTAssertEqual(unpacked?.value, .double(3.14))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }
}
