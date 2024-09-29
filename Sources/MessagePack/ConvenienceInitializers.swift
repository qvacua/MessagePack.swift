import Foundation

public extension MessagePackValue {
  init() {
    self = .nil
  }

  init(_ value: Bool) {
    self = .bool(value)
  }

  init(_ value: some SignedInteger) {
    self = .int(Int64(value))
  }

  init(_ value: some UnsignedInteger) {
    self = .uint(UInt64(value))
  }

  init(_ value: Float) {
    self = .float(value)
  }

  init(_ value: Double) {
    self = .double(value)
  }

  init(_ value: String) {
    self = .string(value)
  }

  init(_ value: [MessagePackValue]) {
    self = .array(value)
  }

  init(_ value: [MessagePackValue: MessagePackValue]) {
    self = .map(value)
  }

  init(_ value: Data) {
    self = .binary(value)
  }

  init(type: Int8, data: Data) {
    self = .extended(type, data)
  }
}
