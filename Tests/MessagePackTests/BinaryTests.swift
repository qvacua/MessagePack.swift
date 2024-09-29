import Foundation
@testable import MessagePack
import XCTest

class BinaryTests: XCTestCase {
  let payload = Data([0x00, 0x01, 0x02, 0x03, 0x04])
  let packed = Data([0xC4, 0x05, 0x00, 0x01, 0x02, 0x03, 0x04])

  func testPack() {
    XCTAssertEqual(pack(.binary(self.payload)), self.packed)
  }

  func testUnpack() {
    let unpacked = try? unpack(self.packed)
    XCTAssertEqual(unpacked?.value, .binary(self.payload))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackBinEmpty() {
    let value = Data()
    let expectedPacked = Data([0xC4, 0x00]) + value
    XCTAssertEqual(pack(.binary(value)), expectedPacked)
  }

  func testUnpackBinEmpty() {
    let data = Data()
    let packed = Data([0xC4, 0x00]) + data

    let unpacked = try? unpack(packed, compatibility: true)
    XCTAssertEqual(unpacked?.value, MessagePackValue.binary(data))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackBin16() {
    let value = Data(count: 0xFF)
    let expectedPacked = Data([0xC4, 0xFF]) + value
    XCTAssertEqual(pack(.binary(value)), expectedPacked)
  }

  func testUnpackBin16() {
    let data = Data([0xC4, 0xFF]) + Data(count: 0xFF)
    let value = Data(count: 0xFF)

    let unpacked = try? unpack(data)
    XCTAssertEqual(unpacked?.value, .binary(value))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackBin32() {
    let value = Data(count: 0x100)
    let expectedPacked = Data([0xC5, 0x01, 0x00]) + value
    XCTAssertEqual(pack(.binary(value)), expectedPacked)
  }

  func testUnpackBin32() {
    let data = Data([0xC5, 0x01, 0x00]) + Data(count: 0x100)
    let value = Data(count: 0x100)

    let unpacked = try? unpack(data)
    XCTAssertEqual(unpacked?.value, .binary(value))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackBin64() {
    let value = Data(count: 0x10000)
    let expectedPacked = Data([0xC6, 0x00, 0x01, 0x00, 0x00]) + value
    XCTAssertEqual(pack(.binary(value)), expectedPacked)
  }

  func testUnpackBin64() {
    let data = Data([0xC6, 0x00, 0x01, 0x00, 0x00]) + Data(count: 0x10000)
    let value = Data(count: 0x10000)

    let unpacked = try? unpack(data)
    XCTAssertEqual(unpacked?.value, .binary(value))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testUnpackInsufficientData() {
    let dataArray: [Data] = [
      // only type byte
      Data([0xC4]), Data([0xC5]), Data([0xC6]),

      // type byte with no data
      Data([0xC4, 0x01]),
      Data([0xC5, 0x00, 0x01]),
      Data([0xC6, 0x00, 0x00, 0x00, 0x01]),
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

  func testUnpackFixstrWithCompatibility() {
    let data = Data([
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
    let packed = Data([0xAD]) + data

    let unpacked = try? unpack(packed, compatibility: true)
    XCTAssertEqual(unpacked?.value, .binary(data))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testUnpackStr8WithCompatibility() {
    let data = Data(count: 0x20)
    let packed = Data([0xD9, 0x20]) + data

    let unpacked = try? unpack(packed, compatibility: true)
    XCTAssertEqual(unpacked?.value, .binary(data))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testUnpackStr16WithCompatibility() {
    let data = Data(count: 0x1000)
    let packed = Data([0xDA, 0x10, 0x00]) + data

    let unpacked = try? unpack(packed, compatibility: true)
    XCTAssertEqual(unpacked?.value, .binary(data))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testUnpackStr32WithCompatibility() {
    let data = Data(count: 0x10000)
    let packed = Data([0xDB, 0x00, 0x01, 0x00, 0x00]) + data

    let unpacked = try? unpack(packed, compatibility: true)
    XCTAssertEqual(unpacked?.value, MessagePackValue.binary(data))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }
}
