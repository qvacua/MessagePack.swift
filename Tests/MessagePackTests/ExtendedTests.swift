import Foundation
@testable import MessagePack
import Testing

struct ExtendedTests {
  @Test func testPackFixext1() {
    let value = MessagePackValue.extended(5, Data([0x00]))
    let packed = Data([0xD4, 0x05, 0x00])
    #expect(pack(value) == packed)
  }

  @Test func testUnpackFixext1() {
    let packed = Data([0xD4, 0x05, 0x00])
    let value = MessagePackValue.extended(5, Data([0x00]))

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == value)
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackFixext2() {
    let value = MessagePackValue.extended(5, Data([0x00, 0x01]))
    let packed = Data([0xD5, 0x05, 0x00, 0x01])
    #expect(pack(value) == packed)
  }

  @Test func testUnpackFixext2() {
    let packed = Data([0xD5, 0x05, 0x00, 0x01])
    let value = MessagePackValue.extended(5, Data([0x00, 0x01]))

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == value)
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackFixext4() {
    let value = MessagePackValue.extended(5, Data([0x00, 0x01, 0x02, 0x03]))
    let packed = Data([0xD6, 0x05, 0x00, 0x01, 0x02, 0x03])
    #expect(pack(value) == packed)
  }

  @Test func testUnpackFixext4() {
    let packed = Data([0xD6, 0x05, 0x00, 0x01, 0x02, 0x03])
    let value = MessagePackValue.extended(5, Data([0x00, 0x01, 0x02, 0x03]))

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == value)
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackFixext8() {
    let value = MessagePackValue.extended(
      5,
      Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
    )
    let packed = Data([0xD7, 0x05, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
    #expect(pack(value) == packed)
  }

  @Test func testUnpackFixext8() {
    let packed = Data([0xD7, 0x05, 0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
    let value = MessagePackValue.extended(
      5,
      Data([0x00, 0x01, 0x02, 0x03, 0x04, 0x05, 0x06, 0x07])
    )

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == value)
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackFixext16() {
    let value = MessagePackValue.extended(
      5,
      Data([
        0x00,
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
        0x09,
        0x0A,
        0x0B,
        0x0C,
        0x0D,
        0x0E,
        0x0F,
      ])
    )
    let packed = Data([
      0xD8,
      0x05,
      0x00,
      0x01,
      0x02,
      0x03,
      0x04,
      0x05,
      0x06,
      0x07,
      0x08,
      0x09,
      0x0A,
      0x0B,
      0x0C,
      0x0D,
      0x0E,
      0x0F,
    ])
    #expect(pack(value) == packed)
  }

  @Test func testUnpackFixext16() {
    let value = MessagePackValue.extended(
      5,
      Data([
        0x00,
        0x01,
        0x02,
        0x03,
        0x04,
        0x05,
        0x06,
        0x07,
        0x08,
        0x09,
        0x0A,
        0x0B,
        0x0C,
        0x0D,
        0x0E,
        0x0F,
      ])
    )
    let packed = Data([
      0xD8,
      0x05,
      0x00,
      0x01,
      0x02,
      0x03,
      0x04,
      0x05,
      0x06,
      0x07,
      0x08,
      0x09,
      0x0A,
      0x0B,
      0x0C,
      0x0D,
      0x0E,
      0x0F,
    ])

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == value)
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackExt8() {
    let payload = Data(count: 7)
    let value = MessagePackValue.extended(5, payload)
    #expect(pack(value) == Data([0xC7, 0x07, 0x05]) + payload)
  }

  @Test func testUnpackExt8() {
    let payload = Data(count: 7)
    let value = MessagePackValue.extended(5, payload)

    let unpacked = try? unpack(Data([0xC7, 0x07, 0x05]) + payload)
    #expect(unpacked?.value == value)
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackExt16() {
    let payload = Data(count: 0x100)
    let value = MessagePackValue.extended(5, payload)
    #expect(pack(value) == Data([0xC8, 0x01, 0x00, 0x05]) + payload)
  }

  @Test func testUnpackExt16() {
    let payload = Data(count: 0x100)
    let value = MessagePackValue.extended(5, payload)

    let unpacked = try? unpack(Data([0xC8, 0x01, 0x00, 0x05]) + payload)
    #expect(unpacked?.value == value)
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackExt32() {
    let payload = Data(count: 0x10000)
    let value = MessagePackValue.extended(5, payload)
    #expect(pack(value) == Data([0xC9, 0x00, 0x01, 0x00, 0x00, 0x05]) + payload)
  }

  @Test func testUnpackExt32() {
    let payload = Data(count: 0x10000)
    let value = MessagePackValue.extended(5, payload)

    let unpacked = try? unpack(Data([0xC9, 0x00, 0x01, 0x00, 0x00, 0x05]) + payload)
    #expect(unpacked?.value == value)
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testUnpackInsufficientData() {
    let dataArray: [Data] = [
      // fixent
      Data([0xD4]), Data([0xD5]), Data([0xD6]), Data([0xD7]), Data([0xD8]),

      // ext 8, 16, 32
      Data([0xC7]), Data([0xC8]), Data([0xC9]),
    ]

    for data in dataArray {
      do {
        _ = try unpack(data)
        Issue.record("Expected unpack to throw")
      } catch {
        #expect(error as? MessagePackError == .insufficientData)
      }
    }
  }
}
