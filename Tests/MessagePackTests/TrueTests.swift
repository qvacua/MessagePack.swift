import Foundation
@testable import MessagePack
import XCTest

class TrueTests: XCTestCase {
  let packed = Data([0xC3])

  func testLiteralConversion() {
    let implicitValue: MessagePackValue = true
    XCTAssertEqual(implicitValue, MessagePackValue.bool(true))
  }

  func testPack() {
    XCTAssertEqual(pack(.bool(true)), self.packed)
  }

  func testUnpack() {
    let unpacked = try? unpack(self.packed)
    XCTAssertEqual(unpacked?.value, MessagePackValue.bool(true))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }
}
