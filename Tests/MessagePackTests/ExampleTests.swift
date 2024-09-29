import Foundation
@testable import MessagePack
import Testing

struct ExampleTests {
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

  @Test func testPack() {
    let packed = pack(example)
    #expect(packed == self.correctA || packed == self.correctB)
  }

  @Test func testUnpack() {
    let unpacked1 = try? unpack(self.correctA)
    #expect(unpacked1?.value == self.example)
    #expect(unpacked1?.remainder.count == 0)

    let unpacked2 = try? unpack(self.correctB)
    #expect(unpacked2?.value == self.example)
    #expect(unpacked2?.remainder.count == 0)
  }

  @Test func testUnpackInvalidData() {
    do {
      _ = try unpack(Data([0xC1]))
      Issue.record("Expected unpack to throw")
    } catch {
      #expect(error as? MessagePackError == .invalidData)
    }
  }

  @Test func testUnpackInsufficientData() {
    do {
      var data = self.correctA
      data.removeLast()
      _ = try unpack(data)
      Issue.record("Expected unpack to throw")
    } catch {
      #expect(error as? MessagePackError == .insufficientData)
    }
  }
}
