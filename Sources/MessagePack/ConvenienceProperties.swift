import Foundation

public extension MessagePackValue {
  /// The number of elements in the `.Array` or `.Map`, `nil` otherwise.
  var count: Int? {
    switch self {
    case let .array(array):
      array.count
    case let .map(dict):
      dict.count
    default:
      nil
    }
  }

  /// The element at subscript `i` in the `.Array`, `nil` otherwise.
  subscript(i: Int) -> MessagePackValue? {
    switch self {
    case let .array(array):
      i < array.count ? array[i] : Optional.none
    default:
      nil
    }
  }

  /// The element at keyed subscript `key`, `nil` otherwise.
  subscript(key: MessagePackValue) -> MessagePackValue? {
    switch self {
    case let .map(dict):
      dict[key]
    default:
      nil
    }
  }

  /// True if `.Nil`, false otherwise.
  var isNil: Bool {
    switch self {
    case .nil:
      true
    default:
      false
    }
  }

  // MARK: Signed integer values

  /// The integer value if `.int` or an appropriately valued `.uint`, `nil` otherwise.
  @available(*, deprecated, message: "use int64Value: instead")
  var integerValue: Int64? {
    switch self {
    case let .int(value):
      value
    case let .uint(value) where value <= UInt64(Int64.max):
      Int64(value)
    default:
      nil
    }
  }

  /// The signed platform-dependent width integer value if `.int` or an
  /// appropriately valued `.uint`, `nil` otherwise.
  var intValue: Int? {
    switch self {
    case let .int(value):
      Int(exactly: value)
    case let .uint(value):
      Int(exactly: value)
    default:
      nil
    }
  }

  /// The signed 8-bit integer value if `.int` or an appropriately valued
  /// `.uint`, `nil` otherwise.
  var int8Value: Int8? {
    switch self {
    case let .int(value):
      Int8(exactly: value)
    case let .uint(value):
      Int8(exactly: value)
    default:
      nil
    }
  }

  /// The signed 16-bit integer value if `.int` or an appropriately valued
  /// `.uint`, `nil` otherwise.
  var int16Value: Int16? {
    switch self {
    case let .int(value):
      Int16(exactly: value)
    case let .uint(value):
      Int16(exactly: value)
    default:
      nil
    }
  }

  /// The signed 32-bit integer value if `.int` or an appropriately valued
  /// `.uint`, `nil` otherwise.
  var int32Value: Int32? {
    switch self {
    case let .int(value):
      Int32(exactly: value)
    case let .uint(value):
      Int32(exactly: value)
    default:
      nil
    }
  }

  /// The signed 64-bit integer value if `.int` or an appropriately valued
  /// `.uint`, `nil` otherwise.
  var int64Value: Int64? {
    switch self {
    case let .int(value):
      value
    case let .uint(value):
      Int64(exactly: value)
    default:
      nil
    }
  }

  // MARK: Unsigned integer values

  /// The unsigned integer value if `.uint` or positive `.int`, `nil` otherwise.
  @available(*, deprecated, message: "use uint64Value: instead")
  var unsignedIntegerValue: UInt64? {
    switch self {
    case let .int(value) where value >= 0:
      UInt64(value)
    case let .uint(value):
      value
    default:
      nil
    }
  }

  /// The unsigned platform-dependent width integer value if `.uint` or an
  /// appropriately valued `.int`, `nil` otherwise.
  var uintValue: UInt? {
    switch self {
    case let .int(value):
      UInt(exactly: value)
    case let .uint(value):
      UInt(exactly: value)
    default:
      nil
    }
  }

  /// The unsigned 8-bit integer value if `.uint` or an appropriately valued
  /// `.int`, `nil` otherwise.
  var uint8Value: UInt8? {
    switch self {
    case let .int(value):
      UInt8(exactly: value)
    case let .uint(value):
      UInt8(exactly: value)
    default:
      nil
    }
  }

  /// The unsigned 16-bit integer value if `.uint` or an appropriately valued
  /// `.int`, `nil` otherwise.
  var uint16Value: UInt16? {
    switch self {
    case let .int(value):
      UInt16(exactly: value)
    case let .uint(value):
      UInt16(exactly: value)
    default:
      nil
    }
  }

  /// The unsigned 32-bit integer value if `.uint` or an appropriately valued
  /// `.int`, `nil` otherwise.
  var uint32Value: UInt32? {
    switch self {
    case let .int(value):
      UInt32(exactly: value)
    case let .uint(value):
      UInt32(exactly: value)
    default:
      nil
    }
  }

  /// The unsigned 64-bit integer value if `.uint` or an appropriately valued
  /// `.int`, `nil` otherwise.
  var uint64Value: UInt64? {
    switch self {
    case let .int(value):
      UInt64(exactly: value)
    case let .uint(value):
      value
    default:
      nil
    }
  }

  /// The contained array if `.Array`, `nil` otherwise.
  var arrayValue: [MessagePackValue]? {
    switch self {
    case let .array(array):
      array
    default:
      nil
    }
  }

  /// The contained boolean value if `.Bool`, `nil` otherwise.
  var boolValue: Bool? {
    switch self {
    case let .bool(value):
      value
    default:
      nil
    }
  }

  /// The contained floating point value if `.Float` or `.Double`, `nil` otherwise.
  var floatValue: Float? {
    switch self {
    case let .float(value):
      value
    case let .double(value):
      Float(exactly: value)
    default:
      nil
    }
  }

  /// The contained double-precision floating point value if `.Float` or `.Double`, `nil` otherwise.
  var doubleValue: Double? {
    switch self {
    case let .float(value):
      Double(exactly: value)
    case let .double(value):
      value
    default:
      nil
    }
  }

  /// The contained string if `.String`, `nil` otherwise.
  var stringValue: String? {
    switch self {
    case let .binary(data):
      String(data: data, encoding: .utf8)
    case let .string(string):
      string
    default:
      nil
    }
  }

  /// The contained data if `.Binary` or `.Extended`, `nil` otherwise.
  var dataValue: Data? {
    switch self {
    case let .binary(bytes):
      bytes
    case let .extended(_, data):
      data
    default:
      nil
    }
  }

  /// The contained type and data if Extended, `nil` otherwise.
  var extendedValue: (Int8, Data)? {
    if case let .extended(type, data) = self {
      (type, data)
    } else {
      nil
    }
  }

  /// The contained type if `.Extended`, `nil` otherwise.
  var extendedType: Int8? {
    if case let .extended(type, _) = self {
      type
    } else {
      nil
    }
  }

  /// The contained dictionary if `.Map`, `nil` otherwise.
  var dictionaryValue: [MessagePackValue: MessagePackValue]? {
    if case let .map(dict) = self {
      dict
    } else {
      nil
    }
  }
}
