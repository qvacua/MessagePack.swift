import Foundation
@testable import MessagePack
import XCTest

class ConvenienceInitializersTests: XCTestCase {
  static var allTests = [
    ("testNil", testNil),
    ("testBool", testBool),
    ("testUInt", testUInt),
    ("testInt", testInt),
    ("testFloat", testFloat),
    ("testDouble", testDouble),
    ("testString", testString),
    ("testArray", testArray),
    ("testMap", testMap),
    ("testBinary", testBinary),
    ("testExtended", testExtended),
  ]

  func testNil() {
    XCTAssertEqual(MessagePackValue(), MessagePackValue.nil)
  }

  func testBool() {
    XCTAssertEqual(MessagePackValue(true), MessagePackValue.bool(true))
    XCTAssertEqual(MessagePackValue(false), MessagePackValue.bool(false))
  }

  func testUInt() {
    XCTAssertEqual(MessagePackValue(0 as UInt), MessagePackValue.uint(0))
    XCTAssertEqual(MessagePackValue(0xFF as UInt8), MessagePackValue.uint(0xFF))
    XCTAssertEqual(MessagePackValue(0xFFFF as UInt16), MessagePackValue.uint(0xFFFF))
    XCTAssertEqual(MessagePackValue(0xFFFF_FFFF as UInt32), MessagePackValue.uint(0xFFFF_FFFF))
    XCTAssertEqual(
      MessagePackValue(0xFFFF_FFFF_FFFF_FFFF as UInt64),
      MessagePackValue.uint(0xFFFF_FFFF_FFFF_FFFF)
    )
  }

  func testInt() {
    XCTAssertEqual(MessagePackValue(-1 as Int), MessagePackValue.int(-1))
    XCTAssertEqual(MessagePackValue(-0x7F as Int8), MessagePackValue.int(-0x7F))
    XCTAssertEqual(MessagePackValue(-0x7FFF as Int16), MessagePackValue.int(-0x7FFF))
    XCTAssertEqual(MessagePackValue(-0x7FFF_FFFF as Int32), MessagePackValue.int(-0x7FFF_FFFF))
    XCTAssertEqual(
      MessagePackValue(-0x7FFF_FFFF_FFFF_FFFF as Int64),
      MessagePackValue.int(-0x7FFF_FFFF_FFFF_FFFF)
    )
  }

  func testFloat() {
    XCTAssertEqual(MessagePackValue(0 as Float), MessagePackValue.float(0))
    XCTAssertEqual(MessagePackValue(1.618 as Float), MessagePackValue.float(1.618))
    XCTAssertEqual(MessagePackValue(3.14 as Float), MessagePackValue.float(3.14))
  }

  func testDouble() {
    XCTAssertEqual(MessagePackValue(0 as Double), MessagePackValue.double(0))
    XCTAssertEqual(MessagePackValue(1.618 as Double), MessagePackValue.double(1.618))
    XCTAssertEqual(MessagePackValue(3.14 as Double), MessagePackValue.double(3.14))
  }

  func testString() {
    XCTAssertEqual(MessagePackValue("Hello, world!"), MessagePackValue.string("Hello, world!"))
  }

  func testArray() {
    XCTAssertEqual(
      MessagePackValue([.uint(0), .uint(1), .uint(2), .uint(3), .uint(4)]),
      MessagePackValue.array([.uint(0), .uint(1), .uint(2), .uint(3), .uint(4)])
    )
  }

  func testMap() {
    XCTAssertEqual(
      MessagePackValue([.string("c"): .string("cookie")]),
      MessagePackValue.map([.string("c"): .string("cookie")])
    )
  }

  func testBinary() {
    let data = Data([0x00, 0x01, 0x02, 0x03, 0x04])
    XCTAssertEqual(MessagePackValue(data), MessagePackValue.binary(data))
  }

  func testExtended() {
    let type: Int8 = 9
    let data = Data([0x00, 0x01, 0x02, 0x03, 0x04])
    XCTAssertEqual(
      MessagePackValue(type: type, data: data),
      MessagePackValue.extended(type, data)
    )
  }
}
