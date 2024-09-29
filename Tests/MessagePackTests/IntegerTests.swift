import Foundation
@testable import MessagePack
import Testing

struct IntegerTests {
  @Test func testPosLiteralConversion() {
    let implicitValue: MessagePackValue = -1
    #expect(implicitValue == MessagePackValue.int(-1))
  }

  @Test func testNegLiteralConversion() {
    let implicitValue: MessagePackValue = 42
    #expect(implicitValue == MessagePackValue.uint(42))
  }

  @Test func testPackNegFixint() {
    #expect(pack(.int(-1)) == Data([0xFF]))
  }

  @Test func testUnpackNegFixint() {
    let unpacked1 = try? unpack(Data([0xFF]))
    #expect(unpacked1?.value == .int(-1))
    #expect(unpacked1?.remainder.count == 0)

    let unpacked2 = try? unpack(Data([0xE0]))
    #expect(unpacked2?.value == .int(-32))
    #expect(unpacked2?.remainder.count == 0)
  }

  @Test func testPackPosFixintSigned() {
    #expect(pack(.int(1)) == Data([0x01]))
  }

  @Test func testUnpackPosFixintSigned() {
    let unpacked = try? unpack(Data([0x01]))
    #expect(unpacked?.value == .int(1))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackPosFixintUnsigned() {
    #expect(pack(.uint(42)) == Data([0x2A]))
  }

  @Test func testUnpackPosFixintUnsigned() {
    let unpacked = try? unpack(Data([0x2A]))
    #expect(unpacked?.value == .uint(42))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackUInt8() {
    #expect(pack(.uint(0xFF)) == Data([0xCC, 0xFF]))
  }

  @Test func testUnpackUInt8() {
    let unpacked = try? unpack(Data([0xCC, 0xFF]))
    #expect(unpacked?.value == .uint(0xFF))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackUInt16() {
    #expect(pack(.uint(0xFFFF)) == Data([0xCD, 0xFF, 0xFF]))
  }

  @Test func testUnpackUInt16() {
    let unpacked = try? unpack(Data([0xCD, 0xFF, 0xFF]))
    #expect(unpacked?.value == .uint(0xFFFF))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackUInt32() {
    #expect(pack(.uint(0xFFFF_FFFF)) == Data([0xCE, 0xFF, 0xFF, 0xFF, 0xFF]))
  }

  @Test func testUnpackUInt32() {
    let unpacked = try? unpack(Data([0xCE, 0xFF, 0xFF, 0xFF, 0xFF]))
    #expect(unpacked?.value == .uint(0xFFFF_FFFF))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackUInt64() {
    #expect(
      pack(.uint(0xFFFF_FFFF_FFFF_FFFF)) ==
      Data([0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
    )
  }

  @Test func testUnpackUInt64() {
    let unpacked = try? unpack(Data([0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]))
    #expect(unpacked?.value == .uint(0xFFFF_FFFF_FFFF_FFFF))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackInt8() {
    #expect(pack(.int(-0x7F)) == Data([0xD0, 0x81]))
  }

  @Test func testUnpackInt8() {
    let unpacked = try? unpack(Data([0xD0, 0x81]))
    #expect(unpacked?.value == .int(-0x7F))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackInt16() {
    #expect(pack(.int(-0x7FFF)) == Data([0xD1, 0x80, 0x01]))
  }

  @Test func testUnpackInt16() {
    let unpacked = try? unpack(Data([0xD1, 0x80, 0x01]))
    #expect(unpacked?.value == .int(-0x7FFF))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackInt32() {
    #expect(pack(.int(-0x10000)) == Data([0xD2, 0xFF, 0xFF, 0x00, 0x00]))
  }

  @Test func testUnpackInt32() {
    let unpacked = try? unpack(Data([0xD2, 0xFF, 0xFF, 0x00, 0x00]))
    #expect(unpacked?.value == .int(-0x10000))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackInt64() {
    #expect(
      pack(.int(-0x1_0000_0000)) ==
      Data([0xD3, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00])
    )
  }

  @Test func testUnpackInt64() {
    let unpacked = try? unpack(Data([0xD3, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00]))
    #expect(unpacked?.value == .int(-0x1_0000_0000))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testUnpackInsufficientData() {
    let dataArray: [Data] = [
      Data([0xD0]),
      Data([0xD1]),
      Data([0xD2]),
      Data([0xD3]),
      Data([0xD4]),
    ]
    for data in dataArray {
      do {
        _ = try unpack(data)
        Issue.record("Expected unpack to throw")
      } catch {
        #expect(error as? MessagePackError == .insufficientData)
      }
    }
  }
}
