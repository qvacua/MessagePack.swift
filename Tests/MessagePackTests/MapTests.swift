import Foundation
@testable import MessagePack
import Testing

func map(_ count: Int) -> [MessagePackValue: MessagePackValue] {
  var dict = [MessagePackValue: MessagePackValue]()
  for i in 0..<Int64(count) {
    dict[.int(i)] = .nil
  }

  return dict
}

func payload(_ count: Int) -> Data {
  var data = Data()
  for i in 0..<Int64(count) {
    data.append(pack(.int(i)) + pack(.nil))
  }

  return data
}

func testPackMap(_ count: Int, prefix: Data) {
  let packed = pack(.map(map(count)))

  #expect(packed.subdata(in: 0..<prefix.count) == prefix)

  var remainder = Subdata(data: packed, startIndex: prefix.count, endIndex: packed.count)
  var keys = Set<Int>()
  do {
    for _ in 0..<count {
      let value: MessagePackValue
      (value, remainder) = try unpack(remainder)
      let key = Int(value.int64Value!)

      #expect(!keys.contains(key))
      keys.insert(key)

      let nilValue: MessagePackValue
      (nilValue, remainder) = try unpack(remainder)
      #expect(nilValue == MessagePackValue.nil)
    }
  } catch {
    print(error)
    Issue.record(error)
  }

  #expect(keys.count == count)
}

struct MapTests {
  @Test func testLiteralConversion() {
    let implicitValue: MessagePackValue = ["c": "cookie"]
    #expect(implicitValue == MessagePackValue.map([.string("c"): .string("cookie")]))
  }

  @Test func testPackFixmap() {
    let packed = Data([0x81, 0xA1, 0x63, 0xA6, 0x63, 0x6F, 0x6F, 0x6B, 0x69, 0x65])
    #expect(pack(.map([.string("c"): .string("cookie")])) == packed)
  }

  @Test func testUnpackFixmap() {
    let packed = Data([0x81, 0xA1, 0x63, 0xA6, 0x63, 0x6F, 0x6F, 0x6B, 0x69, 0x65])

    let unpacked = try? unpack(packed)
    #expect(unpacked?.value == MessagePackValue.map([.string("c"): .string("cookie")]))
    #expect(unpacked?.remainder.count == 0)
  }

  @Test func testPackMap16() {
    testPackMap(16, prefix: Data([0xDE, 0x00, 0x10]))
  }

  @Test func testUnpackMap16() {
    let unpacked = try? unpack(Data([0xDE, 0x00, 0x10]) + payload(16))
    #expect(unpacked?.value == MessagePackValue.map(map(16)))
    #expect(unpacked?.remainder.count == 0)
  }
}
