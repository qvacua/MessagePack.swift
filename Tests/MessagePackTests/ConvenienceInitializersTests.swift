import Foundation
@testable import MessagePack
import Testing

struct ConvenienceInitializersTests {
  @Test func testNil() {
    #expect(MessagePackValue() == MessagePackValue.nil)
  }

  @Test func testBool() {
    #expect(MessagePackValue(true) == MessagePackValue.bool(true))
    #expect(MessagePackValue(false) == MessagePackValue.bool(false))
  }

  @Test func testUInt() {
    #expect(MessagePackValue(0 as UInt) == MessagePackValue.uint(0))
    #expect(MessagePackValue(0xFF as UInt8) == MessagePackValue.uint(0xFF))
    #expect(MessagePackValue(0xFFFF as UInt16) == MessagePackValue.uint(0xFFFF))
    #expect(MessagePackValue(0xFFFF_FFFF as UInt32) == MessagePackValue.uint(0xFFFF_FFFF))
    #expect(
      MessagePackValue(0xFFFF_FFFF_FFFF_FFFF as UInt64) ==
      MessagePackValue.uint(0xFFFF_FFFF_FFFF_FFFF)
    )
  }

  @Test func testInt() {
    #expect(MessagePackValue(-1 as Int) == MessagePackValue.int(-1))
    #expect(MessagePackValue(-0x7F as Int8) == MessagePackValue.int(-0x7F))
    #expect(MessagePackValue(-0x7FFF as Int16) == MessagePackValue.int(-0x7FFF))
    #expect(MessagePackValue(-0x7FFF_FFFF as Int32) == MessagePackValue.int(-0x7FFF_FFFF))
    #expect(
      MessagePackValue(-0x7FFF_FFFF_FFFF_FFFF as Int64) ==
      MessagePackValue.int(-0x7FFF_FFFF_FFFF_FFFF)
    )
  }

  @Test func testFloat() {
    #expect(MessagePackValue(0 as Float) == MessagePackValue.float(0))
    #expect(MessagePackValue(1.618 as Float) == MessagePackValue.float(1.618))
    #expect(MessagePackValue(3.14 as Float) == MessagePackValue.float(3.14))
  }

  @Test func testDouble() {
    #expect(MessagePackValue(0 as Double) == MessagePackValue.double(0))
    #expect(MessagePackValue(1.618 as Double) == MessagePackValue.double(1.618))
    #expect(MessagePackValue(3.14 as Double) == MessagePackValue.double(3.14))
  }

  @Test func testString() {
    #expect(MessagePackValue("Hello, world!") == MessagePackValue.string("Hello, world!"))
  }

  @Test func testArray() {
    #expect(
      MessagePackValue([.uint(0), .uint(1), .uint(2), .uint(3), .uint(4)]) ==
      MessagePackValue.array([.uint(0), .uint(1), .uint(2), .uint(3), .uint(4)])
    )
  }

  @Test func testMap() {
    #expect(
      MessagePackValue([.string("c"): .string("cookie")]) ==
      MessagePackValue.map([.string("c"): .string("cookie")])
    )
  }

  @Test func testBinary() {
    let data = Data([0x00, 0x01, 0x02, 0x03, 0x04])
    #expect(MessagePackValue(data) == MessagePackValue.binary(data))
  }

  @Test func testExtended() {
    let type: Int8 = 9
    let data = Data([0x00, 0x01, 0x02, 0x03, 0x04])
    #expect(
      MessagePackValue(type: type, data: data) ==
      MessagePackValue.extended(type, data)
    )
  }
}
