import Foundation
@testable import MessagePack
import Testing

struct DoubleTests {
  @Test func testLiteralConversion() {
    let implicitValue: MessagePackValue = 3.14
    #expect(implicitValue == MessagePackValue.double(3.14))
  }

  let packed = Data([0xCB, 0x40, 0x09, 0x1E, 0xB8, 0x51, 0xEB, 0x85, 0x1F])

  @Test func testPack() {
    #expect(pack(.double(3.14)) == self.packed)
  }

  @Test func testUnpack() {
    let unpacked = try? unpack(self.packed)
    #expect(unpacked?.value == .double(3.14))
    #expect(unpacked?.remainder.count == 0)
  }
}
