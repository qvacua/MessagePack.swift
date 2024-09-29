import Foundation
@testable import MessagePack
import Testing

struct StringTests {
  @Test func testLiteralConversion() {
    var implicitValue: MessagePackValue

    implicitValue = "Hello, world!"
    #expect(implicitValue == .string("Hello, world!"))

    implicitValue = MessagePackValue(extendedGraphemeClusterLiteral: "Hello, world!")
    #expect(implicitValue == .string("Hello, world!"))

    implicitValue = MessagePackValue(unicodeScalarLiteral: "Hello, world!")
    #expect(implicitValue == .string("Hello, world!"))
  }

  @Test func testPackFixstr() {
    let packed = Data([
      0xAD,
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
    ])
    #expect(pack(.string("Hello, world!")) == packed)
  }

  @Test func testUnpackFixstr() {
    let packed = Data([
      0xAD,
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
    ])

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == .string("Hello, world!"))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testUnpackFixstrEmpty() {
    let packed = Data([0xA0])

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == .string(""))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackStr8() {
    let string = String(repeating: "*", count: 0x20)
    #expect(pack(.string(string)) == Data([0xD9, 0x20]) + string.data(using: .utf8)!)
  }

  @Test func testUnpackStr8() {
    let string = String(repeating: "*", count: 0x20)
    let packed = Data([0xD9, 0x20]) + string.data(using: .utf8)!

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == .string(string))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackStr16() {
    let string = String(repeating: "*", count: 0x1000)
    #expect(pack(.string(string)) == [0xDA, 0x10, 0x00] + string.data(using: .utf8)!)
  }

  @Test func testUnpackStr16() {
    let string = String(repeating: "*", count: 0x1000)
    let packed = Data([0xDA, 0x10, 0x00]) + string.data(using: .utf8)!

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == .string(string))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackStr32() {
    let string = String(repeating: "*", count: 0x10000)
    #expect(
      pack(.string(string)) ==
        Data([0xDB, 0x00, 0x01, 0x00, 0x00]) + string.data(using: .utf8)!
    )
  }

  @Test func testUnpackStr32() {
    let string = String(repeating: "*", count: 0x10000)
    let packed = Data([0xDB, 0x00, 0x01, 0x00, 0x00]) + string.data(using: .utf8)!

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == .string(string))
    #expect(unpacked?.remainder.count == 0)
  }
}
