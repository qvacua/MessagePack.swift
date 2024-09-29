import Foundation
@testable import MessagePack
import XCTest

class ExampleTests: XCTestCase {
  static var allTests = [
    ("testPack", testPack),
    ("testUnpack", testUnpack),
    ("testUnpackInvalidData", testUnpackInvalidData),
    ("testUnpackInsufficientData", testUnpackInsufficientData),
  ]

  let example: MessagePackValue = ["compact": true, "schema": 0]

  // Two possible "correct" values because dictionaries are unordered
  let correctA = Data([
    0x82,
    0xA7,
    0x63,
    0x6F,
    0x6D,
    0x70,
    0x61,
    0x63,
    0x74,
    0xC3,
    0xA6,
    0x73,
    0x63,
    0x68,
    0x65,
    0x6D,
    0x61,
    0x00,
  ])
  let correctB = Data([
    0x82,
    0xA6,
    0x73,
    0x63,
    0x68,
    0x65,
    0x6D,
    0x61,
    0x00,
    0xA7,
    0x63,
    0x6F,
    0x6D,
    0x70,
    0x61,
    0x63,
    0x74,
    0xC3,
  ])

  func testPack() {
    let packed = pack(example)
    XCTAssertTrue(packed == self.correctA || packed == self.correctB)
  }

  func testUnpack() {
    let unpacked1 = try? unpack(self.correctA)
    XCTAssertEqual(unpacked1?.value, self.example)
    XCTAssertEqual(unpacked1?.remainder.count, 0)

    let unpacked2 = try? unpack(self.correctB)
    XCTAssertEqual(unpacked2?.value, self.example)
    XCTAssertEqual(unpacked2?.remainder.count, 0)
  }

  func testUnpackInvalidData() {
    do {
      _ = try unpack(Data([0xC1]))
      XCTFail("Expected unpack to throw")
    } catch {
      XCTAssertEqual(error as? MessagePackError, .invalidData)
    }
  }

  func testUnpackInsufficientData() {
    do {
      var data = self.correctA
      data.removeLast()
      _ = try unpack(data)
      XCTFail("Expected unpack to throw")
    } catch {
      XCTAssertEqual(error as? MessagePackError, .insufficientData)
    }
  }
}
