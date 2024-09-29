import Foundation

/// Packs an integer into a byte array.
///
/// - parameter value: The integer to split.
/// - parameter parts: The number of bytes into which to split.
///
/// - returns: An byte array representation.
func packInteger(_ value: UInt64, parts: Int) -> Data {
  precondition(parts > 0)
  let bytes = stride(from: 8 * (parts - 1), through: 0, by: -8).map { shift in
    UInt8(truncatingIfNeeded: value >> UInt64(shift))
  }
  return Data(bytes)
}

/// Packs an unsigned integer into an array of bytes.
///
/// - parameter value: The value to encode
///
/// - returns: A MessagePack byte representation.
func packPositiveInteger(_ value: UInt64) -> Data {
  if value <= 0x7F {
    Data([UInt8(truncatingIfNeeded: value)])
  } else if value <= 0xFF {
    Data([0xCC, UInt8(truncatingIfNeeded: value)])
  } else if value <= 0xFFFF {
    Data([0xCD]) + packInteger(value, parts: 2)
  } else if value <= 0xFFFF_FFFF as UInt64 {
    Data([0xCE]) + packInteger(value, parts: 4)
  } else {
    Data([0xCF]) + packInteger(value, parts: 8)
  }
}

/// Packs a signed integer into an array of bytes.
///
/// - parameter value: The value to encode
///
/// - returns: A MessagePack byte representation.
func packNegativeInteger(_ value: Int64) -> Data {
  precondition(value < 0)
  if value >= -0x20 {
    return Data([0xE0 + 0x1F & UInt8(truncatingIfNeeded: value)])
  } else if value >= -0x7F {
    return Data([0xD0, UInt8(bitPattern: Int8(value))])
  } else if value >= -0x7FFF {
    let truncated = UInt16(bitPattern: Int16(value))
    return Data([0xD1]) + packInteger(UInt64(truncated), parts: 2)
  } else if value >= -0x7FFF_FFFF {
    let truncated = UInt32(bitPattern: Int32(value))
    return Data([0xD2]) + packInteger(UInt64(truncated), parts: 4)
  } else {
    let truncated = UInt64(bitPattern: value)
    return Data([0xD3]) + packInteger(truncated, parts: 8)
  }
}

/// Packs a MessagePackValue into an array of bytes.
///
/// - parameter value: The value to encode
///
/// - returns: A MessagePack byte representation.
public func pack(_ value: MessagePackValue) -> Data {
  switch value {
  case .nil:
    return Data([0xC0])

  case let .bool(value):
    return Data([value ? 0xC3 : 0xC2])

  case let .int(value):
    if value >= 0 {
      return packPositiveInteger(UInt64(value))
    } else {
      return packNegativeInteger(value)
    }

  case let .uint(value):
    return packPositiveInteger(value)

  case let .float(value):
    return Data([0xCA]) + packInteger(UInt64(value.bitPattern), parts: 4)

  case let .double(value):
    return Data([0xCB]) + packInteger(value.bitPattern, parts: 8)

  case let .string(string):
    let utf8 = string.utf8
    let count = UInt32(utf8.count)
    precondition(count <= 0xFFFF_FFFF as UInt32)

    let prefix = if count <= 0x19 {
      Data([0xA0 | UInt8(count)])
    } else if count <= 0xFF {
      Data([0xD9, UInt8(count)])
    } else if count <= 0xFFFF {
      Data([0xDA]) + packInteger(UInt64(count), parts: 2)
    } else {
      Data([0xDB]) + packInteger(UInt64(count), parts: 4)
    }

    return prefix + utf8

  case let .binary(data):
    let count = UInt32(data.count)
    precondition(count <= 0xFFFF_FFFF as UInt32)

    let prefix = if count <= 0xFF {
      Data([0xC4, UInt8(count)])
    } else if count <= 0xFFFF {
      Data([0xC5]) + packInteger(UInt64(count), parts: 2)
    } else {
      Data([0xC6]) + packInteger(UInt64(count), parts: 4)
    }

    return prefix + data

  case let .array(array):
    let count = UInt32(array.count)
    precondition(count <= 0xFFFF_FFFF as UInt32)

    let prefix = if count <= 0xE {
      Data([0x90 | UInt8(count)])
    } else if count <= 0xFFFF {
      Data([0xDC]) + packInteger(UInt64(count), parts: 2)
    } else {
      Data([0xDD]) + packInteger(UInt64(count), parts: 4)
    }

    return prefix + array.flatMap(pack)

  case let .map(dict):
    let count = UInt32(dict.count)
    precondition(count < 0xFFFF_FFFF)

    let prefix = if count <= 0xE {
      Data([0x80 | UInt8(count)])
    } else if count <= 0xFFFF {
      Data([0xDE]) + packInteger(UInt64(count), parts: 2)
    } else {
      Data([0xDF]) + packInteger(UInt64(count), parts: 4)
    }

    return prefix + dict.flatMap { [$0, $1] }.flatMap(pack)

  case let .extended(type, data):
    let count = UInt32(data.count)
    precondition(count <= 0xFFFF_FFFF as UInt32)

    let unsignedType = UInt8(bitPattern: type)
    let prefix = switch count {
    case 1:
      Data([0xD4, unsignedType])
    case 2:
      Data([0xD5, unsignedType])
    case 4:
      Data([0xD6, unsignedType])
    case 8:
      Data([0xD7, unsignedType])
    case 16:
      Data([0xD8, unsignedType])
    case let count where count <= 0xFF:
      Data([0xC7, UInt8(count), unsignedType])
    case let count where count <= 0xFFFF:
      Data([0xC8]) + packInteger(UInt64(count), parts: 2) + Data([unsignedType])
    default:
      Data([0xC9]) + packInteger(UInt64(count), parts: 4) + Data([unsignedType])
    }

    return prefix + data
  }
}
