import Foundation
@testable import MessagePack
import XCTest

class IntegerTests: XCTestCase {
  static var allTests = [
    ("testPosLiteralConversion", testPosLiteralConversion),
    ("testNegLiteralConversion", testNegLiteralConversion),
    ("testPackNegFixint", testPackNegFixint),
    ("testUnpackNegFixint", testUnpackNegFixint),
    ("testPackPosFixintSigned", testPackPosFixintSigned),
    ("testUnpackPosFixintSigned", testUnpackPosFixintSigned),
    ("testPackPosFixintUnsigned", testPackPosFixintUnsigned),
    ("testUnpackPosFixintUnsigned", testUnpackPosFixintUnsigned),
    ("testPackUInt8", testPackUInt8),
    ("testUnpackUInt8", testUnpackUInt8),
    ("testPackUInt16", testPackUInt16),
    ("testUnpackUInt16", testUnpackUInt16),
    ("testPackUInt32", testPackUInt32),
    ("testUnpackUInt32", testUnpackUInt32),
    ("testPackUInt64", testPackUInt64),
    ("testUnpackUInt64", testUnpackUInt64),
    ("testPackInt8", testPackInt8),
    ("testUnpackInt8", testUnpackInt8),
    ("testPackInt16", testPackInt16),
    ("testUnpackInt16", testUnpackInt16),
    ("testPackInt32", testPackInt32),
    ("testUnpackInt32", testUnpackInt32),
    ("testPackInt64", testPackInt64),
    ("testUnpackInt64", testUnpackInt64),
    ("testUnpackInsufficientData", testUnpackInsufficientData),
  ]

  func testPosLiteralConversion() {
    let implicitValue: MessagePackValue = -1
    XCTAssertEqual(implicitValue, MessagePackValue.int(-1))
  }

  func testNegLiteralConversion() {
    let implicitValue: MessagePackValue = 42
    XCTAssertEqual(implicitValue, MessagePackValue.uint(42))
  }

  func testPackNegFixint() {
    XCTAssertEqual(pack(.int(-1)), Data([0xFF]))
  }

  func testUnpackNegFixint() {
    let unpacked1 = try? unpack(Data([0xFF]))
    XCTAssertEqual(unpacked1?.value, .int(-1))
    XCTAssertEqual(unpacked1?.remainder.count, 0)

    let unpacked2 = try? unpack(Data([0xE0]))
    XCTAssertEqual(unpacked2?.value, .int(-32))
    XCTAssertEqual(unpacked2?.remainder.count, 0)
  }

  func testPackPosFixintSigned() {
    XCTAssertEqual(pack(.int(1)), Data([0x01]))
  }

  func testUnpackPosFixintSigned() {
    let unpacked = try? unpack(Data([0x01]))
    XCTAssertEqual(unpacked?.value, .int(1))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackPosFixintUnsigned() {
    XCTAssertEqual(pack(.uint(42)), Data([0x2A]))
  }

  func testUnpackPosFixintUnsigned() {
    let unpacked = try? unpack(Data([0x2A]))
    XCTAssertEqual(unpacked?.value, .uint(42))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackUInt8() {
    XCTAssertEqual(pack(.uint(0xFF)), Data([0xCC, 0xFF]))
  }

  func testUnpackUInt8() {
    let unpacked = try? unpack(Data([0xCC, 0xFF]))
    XCTAssertEqual(unpacked?.value, .uint(0xFF))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackUInt16() {
    XCTAssertEqual(pack(.uint(0xFFFF)), Data([0xCD, 0xFF, 0xFF]))
  }

  func testUnpackUInt16() {
    let unpacked = try? unpack(Data([0xCD, 0xFF, 0xFF]))
    XCTAssertEqual(unpacked?.value, .uint(0xFFFF))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackUInt32() {
    XCTAssertEqual(pack(.uint(0xFFFF_FFFF)), Data([0xCE, 0xFF, 0xFF, 0xFF, 0xFF]))
  }

  func testUnpackUInt32() {
    let unpacked = try? unpack(Data([0xCE, 0xFF, 0xFF, 0xFF, 0xFF]))
    XCTAssertEqual(unpacked?.value, .uint(0xFFFF_FFFF))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackUInt64() {
    XCTAssertEqual(
      pack(.uint(0xFFFF_FFFF_FFFF_FFFF)),
      Data([0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF])
    )
  }

  func testUnpackUInt64() {
    let unpacked = try? unpack(Data([0xCF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF, 0xFF]))
    XCTAssertEqual(unpacked?.value, .uint(0xFFFF_FFFF_FFFF_FFFF))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackInt8() {
    XCTAssertEqual(pack(.int(-0x7F)), Data([0xD0, 0x81]))
  }

  func testUnpackInt8() {
    let unpacked = try? unpack(Data([0xD0, 0x81]))
    XCTAssertEqual(unpacked?.value, .int(-0x7F))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackInt16() {
    XCTAssertEqual(pack(.int(-0x7FFF)), Data([0xD1, 0x80, 0x01]))
  }

  func testUnpackInt16() {
    let unpacked = try? unpack(Data([0xD1, 0x80, 0x01]))
    XCTAssertEqual(unpacked?.value, .int(-0x7FFF))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackInt32() {
    XCTAssertEqual(pack(.int(-0x10000)), Data([0xD2, 0xFF, 0xFF, 0x00, 0x00]))
  }

  func testUnpackInt32() {
    let unpacked = try? unpack(Data([0xD2, 0xFF, 0xFF, 0x00, 0x00]))
    XCTAssertEqual(unpacked?.value, .int(-0x10000))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackInt64() {
    XCTAssertEqual(
      pack(.int(-0x1_0000_0000)),
      Data([0xD3, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00])
    )
  }

  func testUnpackInt64() {
    let unpacked = try? unpack(Data([0xD3, 0xFF, 0xFF, 0xFF, 0xFF, 0x00, 0x00, 0x00, 0x00]))
    XCTAssertEqual(unpacked?.value, .int(-0x1_0000_0000))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testUnpackInsufficientData() {
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
        XCTFail("Expected unpack to throw")
      } catch {
        XCTAssertEqual(error as? MessagePackError, .insufficientData)
      }
    }
  }
}
