import Foundation
@testable import MessagePack
import XCTest

class ArrayTests: XCTestCase {
  func testLiteralConversion() {
    let implicitValue: MessagePackValue = [0, 1, 2, 3, 4]
    let payload: [MessagePackValue] = [.uint(0), .uint(1), .uint(2), .uint(3), .uint(4)]
    XCTAssertEqual(implicitValue, .array(payload))
  }

  func testPackFixarray() {
    let value: [MessagePackValue] = [.uint(0), .uint(1), .uint(2), .uint(3), .uint(4)]
    let packed = Data([0x95, 0x00, 0x01, 0x02, 0x03, 0x04])
    XCTAssertEqual(pack(.array(value)), packed)
  }

  func testUnpackFixarray() {
    let packed = Data([0x95, 0x00, 0x01, 0x02, 0x03, 0x04])
    let value: [MessagePackValue] = [.uint(0), .uint(1), .uint(2), .uint(3), .uint(4)]

    let unpacked = try? unpack(packed)
    XCTAssertEqual(unpacked?.value, .array(value))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }

  func testPackArray16() {
    let value = [MessagePackValue](repeating: nil, count: 16)
    let packed = Data([0xDC, 0x00, 0x10] + [UInt8](repeating: 0xC0, count: 16))
    XCTAssertEqual(pack(.array(value)), packed)
  }

  func testUnpackArray16() {
    let packed = Data([0xDC, 0x00, 0x10] + [UInt8](repeating: 0xC0, count: 16))
    let value = [MessagePackValue](repeating: nil, count: 16)

    let unpacked = try? unpack(packed)
    XCTAssertEqual(unpacked?.value, .array(value))
    XCTAssertEqual(unpacked?.remainder.count, 0)
  }
}
