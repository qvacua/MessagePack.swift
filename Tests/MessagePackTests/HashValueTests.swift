import Foundation
@testable import MessagePack
import Testing

struct HashValueTests {
  @Test func testNilHashValue() {
    #expect(MessagePackValue.nil.hashValue == 0)
  }

  @Test func testBoolHashValue() {
    #expect(MessagePackValue.bool(true).hashValue == true.hashValue)
    #expect(MessagePackValue.bool(false).hashValue == false.hashValue)
  }

  @Test func testIntHashValue() {
    #expect(MessagePackValue.int(-1).hashValue == Int64(-1).hashValue)
    #expect(MessagePackValue.int(0).hashValue == Int64(0).hashValue)
    #expect(MessagePackValue.int(1).hashValue == Int64(1).hashValue)
  }

  @Test func testUIntHashValue() {
    #expect(MessagePackValue.uint(0).hashValue == UInt64(0).hashValue)
    #expect(MessagePackValue.uint(1).hashValue == UInt64(1).hashValue)
    #expect(MessagePackValue.uint(2).hashValue == UInt64(2).hashValue)
  }

  @Test func testFloatHashValue() {
    #expect(MessagePackValue.float(0).hashValue == Float(0).hashValue)
    #expect(MessagePackValue.float(1.618).hashValue == Float(1.618).hashValue)
    #expect(MessagePackValue.float(3.14).hashValue == Float(3.14).hashValue)
  }

  @Test func testDoubleHashValue() {
    #expect(MessagePackValue.double(0).hashValue == Double(0).hashValue)
    #expect(MessagePackValue.double(1.618).hashValue == Double(1.618).hashValue)
    #expect(MessagePackValue.double(3.14).hashValue == Double(3.14).hashValue)
  }

  @Test func testStringHashValue() {
    #expect(MessagePackValue.string("").hashValue == "".hashValue)
    #expect(MessagePackValue.string("MessagePack").hashValue == "MessagePack".hashValue)
  }

  @Test func testBinaryHashValue() {
    #expect(MessagePackValue.binary(Data()).hashValue == 0)
    #expect(MessagePackValue.binary(Data([0x00, 0x01, 0x02, 0x03, 0x04])).hashValue == 5)
  }

  @Test func testArrayHashValue() {
    let values: [MessagePackValue] = [1, true, ""]
    #expect(MessagePackValue.array(values).hashValue == 3)
  }

  @Test func testMapHashValue() {
    let values: [MessagePackValue: MessagePackValue] = [
      "a": "apple",
      "b": "banana",
      "c": "cookie",
    ]
    #expect(MessagePackValue.map(values).hashValue == 3)
  }

  @Test func testExtendedHashValue() {
    #expect(
      MessagePackValue.extended(5, Data()).hashValue ==
      31 &* Int8(5).hashValue &+ Int(0)
    )
    #expect(
      MessagePackValue.extended(5, Data([0x00, 0x01, 0x02, 0x03, 0x04])).hashValue ==
      31 &* Int8(5).hashValue &+ Int(5)
    )
  }
}
