import Foundation

/// The MessagePackValue enum encapsulates one of the following types: Nil, Bool, Int, UInt, Float,
/// Double, String, Binary, Array, Map, and Extended.
public enum MessagePackValue: Sendable {
  case `nil`
  case bool(Bool)
  case int(Int64)
  case uint(UInt64)
  case float(Float)
  case double(Double)
  case string(String)
  case binary(Data)
  case array([MessagePackValue])
  case map([MessagePackValue: MessagePackValue])
  case extended(Int8, Data)
}

extension MessagePackValue: CustomStringConvertible {
  public var description: String {
    switch self {
    case .nil:
      "nil"
    case let .bool(value):
      "bool(\(value))"
    case let .int(value):
      "int(\(value))"
    case let .uint(value):
      "uint(\(value))"
    case let .float(value):
      "float(\(value))"
    case let .double(value):
      "double(\(value))"
    case let .string(string):
      "string(\(string))"
    case let .binary(data):
      "data(\(data))"
    case let .array(array):
      "array(\(array.description))"
    case let .map(dict):
      "map(\(dict.description))"
    case let .extended(type, data):
      "extended(\(type), \(data))"
    }
  }
}

extension MessagePackValue: Equatable {
  public static func == (lhs: MessagePackValue, rhs: MessagePackValue) -> Bool {
    switch (lhs, rhs) {
    case (.nil, .nil):
      true
    case let (.bool(lhv), .bool(rhv)):
      lhv == rhv
    case let (.int(lhv), .int(rhv)):
      lhv == rhv
    case let (.uint(lhv), .uint(rhv)):
      lhv == rhv
    case let (.int(lhv), .uint(rhv)):
      lhv >= 0 && UInt64(lhv) == rhv
    case let (.uint(lhv), .int(rhv)):
      rhv >= 0 && lhv == UInt64(rhv)
    case let (.float(lhv), .float(rhv)):
      lhv == rhv
    case let (.double(lhv), .double(rhv)):
      lhv == rhv
    case let (.string(lhv), .string(rhv)):
      lhv == rhv
    case let (.binary(lhv), .binary(rhv)):
      lhv == rhv
    case let (.array(lhv), .array(rhv)):
      lhv == rhv
    case let (.map(lhv), .map(rhv)):
      lhv == rhv
    case let (.extended(lht, lhb), .extended(rht, rhb)):
      lht == rht && lhb == rhb
    default:
      false
    }
  }
}

extension MessagePackValue: Hashable {
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.hashValue)
  }

  public var hashValue: Int {
    switch self {
    case .nil: 0
    case let .bool(value): value.hashValue
    case let .int(value): value.hashValue
    case let .uint(value): value.hashValue
    case let .float(value): value.hashValue
    case let .double(value): value.hashValue
    case let .string(string): string.hashValue
    case let .binary(data): data.count
    case let .array(array): array.count
    case let .map(dict): dict.count
    case let .extended(type, data): 31 &* type.hashValue &+ data.count
    }
  }
}

public enum MessagePackError: Error {
  case invalidArgument
  case insufficientData
  case invalidData
}
