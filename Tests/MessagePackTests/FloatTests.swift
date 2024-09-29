import Foundation
@testable import MessagePack
import Testing

struct FloatTests {
  let packed = Data([0xCA, 0x40, 0x48, 0xF5, 0xC3])

  @Test func testPack() {
    #expect(pack(.float(3.14)) == self.packed)
  }

  @Test func testUnpack() {
    let unpacked = try? unpack(self.packed)
    #expect(unpacked?.value == .float(3.14))
    #expect(unpacked?.remainder.count == 0)
  }
}
