import Foundation
@testable import MessagePack
import Numerics
import Testing

struct ConveniencePropertiesTests {
  @Test func testCount() {
    #expect(MessagePackValue.array([0]).count == 1)
    #expect(MessagePackValue.map(["c": "cookie"]).count == 1)
    #expect(MessagePackValue.nil.count == nil)
  }

  @Test func testIndexedSubscript() {
    #expect(MessagePackValue.array([0])[0] == .uint(0))
    #expect(MessagePackValue.array([0])[1] == nil)
    #expect(MessagePackValue.nil[0] == nil)
  }

  @Test func testKeyedSubscript() {
    #expect(MessagePackValue.map(["c": "cookie"])["c"] == "cookie")
    #expect(MessagePackValue.nil["c"] == nil)
  }

  @Test func testIsNil() {
    #expect(MessagePackValue.nil.isNil)
    #expect(!MessagePackValue.bool(true).isNil)
  }

  @Test func testIntValue() {
    #expect(MessagePackValue.int(-1).intValue == -1)
    #expect(MessagePackValue.uint(1).intValue == 1)
    #expect(MessagePackValue.nil.intValue == nil)
  }

  @Test func testInt8Value() {
    #expect(MessagePackValue.int(-1).int8Value == -1)
    #expect(MessagePackValue.int(1).int8Value == 1)
    #expect(MessagePackValue.int(Int64(Int8.min) - 1).int8Value == nil)
    #expect(MessagePackValue.int(Int64(Int8.max) + 1).int8Value == nil)

    #expect(MessagePackValue.uint(1).int8Value == 1)
    #expect(MessagePackValue.uint(UInt64(Int8.max) + 1).int8Value == nil)
    #expect(MessagePackValue.nil.int8Value == nil)
  }

  @Test func testInt16Value() {
    #expect(MessagePackValue.int(-1).int16Value == -1)
    #expect(MessagePackValue.int(1).int16Value == 1)
    #expect(MessagePackValue.int(Int64(Int16.min) - 1).int16Value == nil)
    #expect(MessagePackValue.int(Int64(Int16.max) + 1).int16Value == nil)

    #expect(MessagePackValue.uint(1).int16Value == 1)
    #expect(MessagePackValue.uint(UInt64(Int16.max) + 1).int16Value == nil)
    #expect(MessagePackValue.nil.int16Value == nil)
  }

  @Test func testInt32Value() {
    #expect(MessagePackValue.int(-1).int32Value == -1)
    #expect(MessagePackValue.int(1).int32Value == 1)
    #expect(MessagePackValue.int(Int64(Int32.min) - 1).int32Value == nil)
    #expect(MessagePackValue.int(Int64(Int32.max) + 1).int32Value == nil)

    #expect(MessagePackValue.uint(1).int32Value == 1)
    #expect(MessagePackValue.uint(UInt64(Int32.max) + 1).int32Value == nil)
    #expect(MessagePackValue.nil.int32Value == nil)
  }

  @Test func testInt64Value() {
    #expect(MessagePackValue.int(-1).int64Value == -1)
    #expect(MessagePackValue.int(1).int64Value == 1)

    #expect(MessagePackValue.uint(1).int64Value == 1)
    #expect(MessagePackValue.uint(UInt64(Int64.max) + 1).int64Value == nil)
    #expect(MessagePackValue.nil.int64Value == nil)
  }

  @Test func testUIntValue() {
    #expect(MessagePackValue.uint(1).uintValue == 1)

    #expect(MessagePackValue.int(-1).uintValue == nil)
    #expect(MessagePackValue.int(1).uintValue == 1)
    #expect(MessagePackValue.nil.uintValue == nil)
  }

  @Test func testUInt8Value() {
    #expect(MessagePackValue.uint(1).uint8Value == 1)
    #expect(MessagePackValue.uint(UInt64(UInt8.max) + 1).uint8Value == nil)

    #expect(MessagePackValue.int(-1).uint8Value == nil)
    #expect(MessagePackValue.int(1).uint8Value == 1)
    #expect(MessagePackValue.int(Int64(UInt8.max) + 1).uint8Value == nil)
    #expect(MessagePackValue.nil.uint8Value == nil)
  }

  @Test func testUInt16Value() {
    #expect(MessagePackValue.uint(1).uint16Value == 1)
    #expect(MessagePackValue.uint(UInt64(UInt16.max) + 1).uint16Value == nil)

    #expect(MessagePackValue.int(-1).uint16Value == nil)
    #expect(MessagePackValue.int(1).uint16Value == 1)
    #expect(MessagePackValue.int(Int64(UInt16.max) + 1).uint16Value == nil)
    #expect(MessagePackValue.nil.uint16Value == nil)
  }

  @Test func testUInt32Value() {
    #expect(MessagePackValue.uint(1).uint32Value == 1)
    #expect(MessagePackValue.uint(UInt64(UInt32.max) + 1).uint32Value == nil)

    #expect(MessagePackValue.int(-1).uint32Value == nil)
    #expect(MessagePackValue.int(1).uint32Value == 1)
    #expect(MessagePackValue.int(Int64(UInt32.max) + 1).uint32Value == nil)
    #expect(MessagePackValue.nil.uint32Value == nil)
  }

  @Test func testUInt64Value() {
    #expect(MessagePackValue.uint(1).uint64Value == 1)

    #expect(MessagePackValue.int(-1).uint64Value == nil)
    #expect(MessagePackValue.int(1).uint64Value == 1)
    #expect(MessagePackValue.nil.uint8Value == nil)
  }

  @Test func testArrayValue() {
    let arrayValue = MessagePackValue.array([0]).arrayValue
    #expect(arrayValue != nil)
    #expect(arrayValue! == [0])
    #expect(MessagePackValue.nil.arrayValue == nil)
  }

  @Test func testBoolValue() {
    #expect(MessagePackValue.bool(true).boolValue == true)
    #expect(MessagePackValue.bool(false).boolValue == false)
    #expect(MessagePackValue.nil.boolValue == nil)
  }

  @Test func testFloatValue() {
    #expect(MessagePackValue.nil.floatValue == nil)

    var floatValue = MessagePackValue.float(3.14).floatValue
    #expect(floatValue != nil)
    #expect(floatValue!.isApproximatelyEqual(to: 3.14, absoluteTolerance: 0.0001))

    floatValue = MessagePackValue.double(3.14).floatValue
    #expect(floatValue == nil)
  }

  @Test func testDoubleValue() {
    #expect(MessagePackValue.nil.doubleValue == nil)

    var doubleValue = MessagePackValue.float(3.14).doubleValue
    #expect(doubleValue != nil)
    #expect(doubleValue!.isApproximatelyEqual(to: 3.14, absoluteTolerance: 0.0001))

    doubleValue = MessagePackValue.double(3.14).doubleValue
    #expect(doubleValue != nil)
    #expect(doubleValue!.isApproximatelyEqual(to: 3.14, absoluteTolerance: 0.0001))
  }

  @Test func testStringValue() {
    #expect(MessagePackValue.string("Hello, world!").stringValue == "Hello, world!")
    #expect(MessagePackValue.nil.stringValue == nil)
  }

  @Test func testStringValueWithCompatibility() {
    let stringValue = MessagePackValue.binary(Data([
      0x48,
      0x65,
      0x6C,
      0x6C,
      0x6F,
      0x2C,
      0x20,
      0x77,
      0x6F,
      0x72,
      0x6C,
      0x64,
      0x21,
    ])).stringValue
    #expect(stringValue == "Hello, world!")
  }

  @Test func testDataValue() {
    #expect(MessagePackValue.nil.dataValue == nil)

    var dataValue = MessagePackValue.binary(Data([0x00, 0x01, 0x02, 0x03, 0x04])).dataValue
    #expect(dataValue == Data([0x00, 0x01, 0x02, 0x03, 0x04]))

    dataValue = MessagePackValue.extended(4, Data([0x00, 0x01, 0x02, 0x03, 0x04])).dataValue
    #expect(dataValue == Data([0x00, 0x01, 0x02, 0x03, 0x04]))
  }

  @Test func testExtendedValue() {
    #expect(MessagePackValue.nil.extendedValue == nil)

    let extended = MessagePackValue.extended(4, Data([0x00, 0x01, 0x02, 0x03, 0x04]))
    let tuple = extended.extendedValue
    #expect(tuple != nil)

    let (type, data) = tuple!
    #expect(type == 4)
    #expect(data == Data([0x00, 0x01, 0x02, 0x03, 0x04]))
  }

  @Test func testExtendedType() {
    #expect(MessagePackValue.nil.extendedType == nil)

    let extended = MessagePackValue.extended(4, Data([0x00, 0x01, 0x02, 0x03, 0x04]))
    let type = extended.extendedType
    #expect(type != nil)
    #expect(type! == 4)
  }

  @Test func testMapValue() {
    let dictionaryValue = MessagePackValue.map(["c": "cookie"]).dictionaryValue
    #expect(dictionaryValue != nil)
    #expect(dictionaryValue! == ["c": "cookie"])
    #expect(MessagePackValue.nil.dictionaryValue == nil)
  }
}
