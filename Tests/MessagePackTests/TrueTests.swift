import Foundation
@testable import MessagePack
import Testing

struct TrueTests {
  let packed = Data([0xC3])

  @Test func testLiteralConversion() {
    let implicitValue: MessagePackValue = true
    #expect(implicitValue == MessagePackValue.bool(true))
  }

  @Test func testPack() {
    #expect(pack(.bool(true)) == self.packed)
  }

  @Test func testUnpack() {
    let unpacked = try? unpack(self.packed)
    #expect(unpacked?.value == MessagePackValue.bool(true))
    #expect(unpacked?.remainder.count == 0)
  }
}
