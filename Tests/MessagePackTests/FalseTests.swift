import Foundation
@testable import MessagePack
import Testing

struct FalseTests {
  let packed = Data([0xC2])

  @Test func testLiteralConversion() {
    let implicitValue: MessagePackValue = false
    #expect(implicitValue == MessagePackValue.bool(false))
  }

  @Test func testPack() {
    #expect(pack(.bool(false)) == self.packed)
  }

  @Test func testUnpack() {
    let unpacked = try? unpack(self.packed)
    #expect(unpacked?.value == .bool(false))
    #expect(unpacked?.remainder.count == 0)
  }
}
