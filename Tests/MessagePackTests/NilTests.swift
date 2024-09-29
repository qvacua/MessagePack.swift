import Foundation
@testable import MessagePack
import Testing

struct NilTests {
  let packed = Data([0xC0])

  @Test func testLiteralConversion() {
    let implicitValue: MessagePackValue = nil
    #expect(implicitValue == MessagePackValue.nil)
  }

  @Test func testPack() {
    #expect(pack(.nil) == self.packed)
  }

  @Test func testUnpack() {
    let unpacked = try? unpack(self.packed)
    #expect(unpacked?.value == MessagePackValue.nil)
    #expect(unpacked?.remainder.count == 0)
  }
}
