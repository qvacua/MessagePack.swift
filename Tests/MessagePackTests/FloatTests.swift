import Foundation
@testable import MessagePack
import XCTest

class FloatTests: XCTestCase {
  static var allTests = [
    ("testPack", testPack),
    ("testUnpack", testUnpack),
  ]

  let packed = Data([0xCA, 0x40, 0x48, 0xF5, 0xC3])

  func testPack() {
    XCTAssertEqual(pack(.float(3.14)), self.packed)
  }

  func testUnpack() {
    let unpacked = try? unpack(self.packed)
    XCTAssertEqual(unpacked?.value, .float(3.14))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }
}
