import Foundation
@testable import MessagePack
import Testing

struct SubdataTests {
  @Test func testConversationToSubdata() {
    let data = Data(repeating: 0, count: 0x20)
    let subdata = Subdata(data: data)
    #expect(subdata.base == data)
    #expect(subdata.baseStartIndex == 0)
    #expect(subdata.baseEndIndex == 0x20)
    #expect(subdata.count == 0x20)
    #expect(subdata.data == data)
    #expect(!subdata.isEmpty)
  }

  @Test func testConversationToSubdataWithExplicityIndexes() {
    let data = Data(repeating: 0, count: 0x20)
    let subdata = Subdata(data: data, startIndex: 0x10, endIndex: 0x11)
    #expect(subdata.base == data)
    #expect(subdata.baseStartIndex == 0x10)
    #expect(subdata.baseEndIndex == 0x11)
    #expect(subdata.count == 1)
    #expect(!subdata.isEmpty)
  }

  @Test func testConversationToEmptySubdata() {
    let data = Data(repeating: 0, count: 0x20)
    let subdata = Subdata(data: data, startIndex: 0x10, endIndex: 0x10)
    #expect(subdata.base == data)
    #expect(subdata.baseStartIndex == 0x10)
    #expect(subdata.baseEndIndex == 0x10)
    #expect(subdata.count == 0)
    #expect(subdata.data == Data())
    #expect(subdata.isEmpty)
  }
}
