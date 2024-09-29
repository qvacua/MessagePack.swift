import Foundation
@testable import MessagePack
import Testing

struct EqualityTests {
  @Test func testNilEqualToNil() {
    #expect(MessagePackValue.nil == MessagePackValue.nil)
  }

  @Test func testNilNotEqualToBool() {
    #expect(MessagePackValue.nil != MessagePackValue.bool(false))
  }

  @Test func testBoolEqualToBool() {
    #expect(MessagePackValue.bool(true) == MessagePackValue.bool(true))
    #expect(MessagePackValue.bool(false) == MessagePackValue.bool(false))
    #expect(MessagePackValue.bool(true) != MessagePackValue.bool(false))
    #expect(MessagePackValue.bool(false) != MessagePackValue.bool(true))
  }

  @Test func testIntEqualToInt() {
    #expect(MessagePackValue.int(1) == MessagePackValue.int(1))
  }

  @Test func testUIntEqualToUInt() {
    #expect(MessagePackValue.uint(1) == MessagePackValue.uint(1))
  }

  @Test func testIntEqualToUInt() {
    #expect(MessagePackValue.int(1) == MessagePackValue.uint(1))
  }

  @Test func testUIntEqualToInt() {
    #expect(MessagePackValue.uint(1) == MessagePackValue.int(1))
  }

  @Test func testUIntNotEqualToInt() {
    #expect(MessagePackValue.uint(1) != MessagePackValue.int(-1))
  }

  @Test func testIntNotEqualToUInt() {
    #expect(MessagePackValue.int(-1) != MessagePackValue.uint(1))
  }

  @Test func testFloatEqualToFloat() {
    #expect(MessagePackValue.float(3.14) == MessagePackValue.float(3.14))
  }

  @Test func testDoubleEqualToDouble() {
    #expect(MessagePackValue.double(3.14) == MessagePackValue.double(3.14))
  }

  @Test func testFloatNotEqualToDouble() {
    #expect(MessagePackValue.float(3.14) != MessagePackValue.double(3.14))
  }

  @Test func testDoubleNotEqualToFloat() {
    #expect(MessagePackValue.double(3.14) != MessagePackValue.float(3.14))
  }

  @Test func testStringEqualToString() {
    #expect(
      MessagePackValue.string("Hello, world!") ==
        MessagePackValue.string("Hello, world!")
    )
  }

  @Test func testBinaryEqualToBinary() {
    #expect(
      MessagePackValue.binary(Data([0x00, 0x01, 0x02, 0x03, 0x04])) ==
        MessagePackValue.binary(Data([0x00, 0x01, 0x02, 0x03, 0x04]))
    )
  }

  @Test func testArrayEqualToArray() {
    #expect(
      MessagePackValue.array([0, 1, 2, 3, 4]) ==
        MessagePackValue.array([0, 1, 2, 3, 4])
    )
  }

  @Test func testMapEqualToMap() {
    #expect(
      MessagePackValue.map(["a": "apple", "b": "banana", "c": "cookie"]) ==
        MessagePackValue.map(["b": "banana", "c": "cookie", "a": "apple"])
    )
  }

  @Test func testExtendedEqualToExtended() {
    #expect(
      MessagePackValue.extended(5, Data([0x00, 0x01, 0x02, 0x03, 0x04])) ==
        MessagePackValue.extended(5, Data([0x00, 0x01, 0x02, 0x03, 0x04]))
    )
  }
}
