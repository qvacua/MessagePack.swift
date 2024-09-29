import Foundation
@testable import MessagePack
import Testing

struct DescriptionTests {
  @Test func testNilDescription() {
    #expect(MessagePackValue.nil.description == "nil")
  }

  @Test func testBoolDescription() {
    #expect(MessagePackValue.bool(true).description == "bool(true)")
    #expect(MessagePackValue.bool(false).description == "bool(false)")
  }

  @Test func testIntDescription() {
    #expect(MessagePackValue.int(-1).description == "int(-1)")
    #expect(MessagePackValue.int(0).description == "int(0)")
    #expect(MessagePackValue.int(1).description == "int(1)")
  }

  @Test func testUIntDescription() {
    #expect(MessagePackValue.uint(0).description == "uint(0)")
    #expect(MessagePackValue.uint(1).description == "uint(1)")
    #expect(MessagePackValue.uint(2).description == "uint(2)")
  }

  @Test func testFloatDescription() {
    #expect(MessagePackValue.float(0.0).description == "float(0.0)")
    #expect(MessagePackValue.float(1.618).description == "float(1.618)")
    #expect(MessagePackValue.float(3.14).description == "float(3.14)")
  }

  @Test func testDoubleDescription() {
    #expect(MessagePackValue.double(0.0).description == "double(0.0)")
    #expect(MessagePackValue.double(1.618).description == "double(1.618)")
    #expect(MessagePackValue.double(3.14).description == "double(3.14)")
  }

  @Test func testStringDescription() {
    #expect(MessagePackValue.string("").description == "string()".description)
    #expect(
      MessagePackValue.string("MessagePack").description ==
      "string(MessagePack)".description
    )
  }

  @Test func testBinaryDescription() {
    #expect(MessagePackValue.binary(Data()).description == "data(0 bytes)")
    #expect(
      MessagePackValue.binary(Data(Data([0x00, 0x01, 0x02, 0x03, 0x04]))).description ==
      "data(5 bytes)"
    )
  }

  @Test func testArrayDescription() {
    let values: [MessagePackValue] = [1, true, ""]
    #expect(
      MessagePackValue.array(values).description ==
      "array([int(1), bool(true), string()])"
    )
  }

  @Test func testMapDescription() {
    let values: [MessagePackValue: MessagePackValue] = [
      "a": "apple",
      "b": "banana",
      "c": "cookie",
    ]

    let components = [
      "string(a): string(apple)",
      "string(b): string(banana)",
      "string(c): string(cookie)",
    ]

    let indexPermutations: [[Int]] = [
      [0, 1, 2],
      [0, 2, 1],
      [1, 0, 2],
      [1, 2, 0],
      [2, 0, 1],
      [2, 1, 0],
    ]

    let description = MessagePackValue.map(values).description

    var isValid = false
    for indices in indexPermutations {
      let permutation = indices.map { index in components[index] }
      let innerDescription = permutation.joined(separator: ", ")
      if description == "map([\(innerDescription)])" {
        isValid = true
        break
      }
    }

    #expect(isValid)
  }

  @Test func testExtendedDescription() {
    #expect(MessagePackValue.extended(5, Data()).description == "extended(5, 0 bytes)")
    #expect(
      MessagePackValue.extended(5, Data([0x00, 0x10, 0x20, 0x30, 0x40])).description ==
      "extended(5, 5 bytes)"
    )
  }
}
