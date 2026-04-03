import Foundation

/// Joins bytes to form an integer.
///
/// - parameter data: The input data to unpack.
/// - parameter offset: The current read position; advanced past the read bytes on return.
/// - parameter count: The number of bytes to read.
///
/// - returns: An integer representation of `count` bytes of data.
func unpackInteger(_ data: Data, offset: inout Int, count: Int) throws -> UInt64 {
  guard count > 0 else {
    throw MessagePackError.invalidArgument
  }

  let end = offset + count
  guard end <= data.endIndex else {
    throw MessagePackError.insufficientData
  }

  var value: UInt64 = 0
  for i in offset..<end {
    value = value << 8 | UInt64(data[i])
  }
  offset = end
  return value
}

/// Joins bytes to form a string.
///
/// - parameter data: The input data to unpack.
/// - parameter offset: The current read position; advanced past the read bytes on return.
/// - parameter count: The length of the string in bytes.
///
/// - returns: A string representation of `count` bytes of data.
func unpackString(_ data: Data, offset: inout Int, count: Int) throws -> String {
  guard count > 0 else {
    return ""
  }

  let end = offset + count
  guard end <= data.endIndex else {
    throw MessagePackError.insufficientData
  }

  guard let result = String(data: data[offset..<end], encoding: .utf8) else {
    throw MessagePackError.invalidData
  }
  offset = end
  return result
}

/// Reads `count` bytes from `data` starting at `offset` as raw Data.
///
/// - parameter data: The input data to unpack.
/// - parameter offset: The current read position; advanced past the read bytes on return.
/// - parameter count: The number of bytes to read.
///
/// - returns: A subsection of data representing `count` bytes.
func unpackData(_ data: Data, offset: inout Int, count: Int) throws -> Data {
  let end = offset + count
  guard end <= data.endIndex else {
    throw MessagePackError.insufficientData
  }

  let result = data[offset..<end]
  offset = end
  return result
}

/// Reads a single byte from `data` at `offset` and advances.
func unpackByte(_ data: Data, offset: inout Int) throws -> UInt8 {
  guard offset < data.endIndex else {
    throw MessagePackError.insufficientData
  }
  let byte = data[offset]
  offset += 1
  return byte
}

/// Joins bytes to form an array of `MessagePackValue` values.
///
/// - parameter data: The input data to unpack.
/// - parameter offset: The current read position; advanced past the read bytes on return.
/// - parameter count: The number of elements to unpack.
/// - parameter compatibility: When true, unpacks strings as binary data.
///
/// - returns: An array of `count` elements.
func unpackArray(
  _ data: Data,
  offset: inout Int,
  count: Int,
  compatibility: Bool
) throws -> [MessagePackValue] {
  var values = [MessagePackValue]()
  values.reserveCapacity(count)
  for _ in 0..<count {
    values.append(try unpackValue(data, offset: &offset, compatibility: compatibility))
  }
  return values
}

/// Joins bytes to form a dictionary with `MessagePackValue` key/value entries.
///
/// - parameter data: The input data to unpack.
/// - parameter offset: The current read position; advanced past the read bytes on return.
/// - parameter count: The number of key-value pairs to unpack.
/// - parameter compatibility: When true, unpacks strings as binary data.
///
/// - returns: A dictionary of `count` entries.
func unpackMap(
  _ data: Data,
  offset: inout Int,
  count: Int,
  compatibility: Bool
) throws -> [MessagePackValue: MessagePackValue] {
  var dict = [MessagePackValue: MessagePackValue](minimumCapacity: count)
  for _ in 0..<count {
    let key = try unpackValue(data, offset: &offset, compatibility: compatibility)
    let value = try unpackValue(data, offset: &offset, compatibility: compatibility)
    dict[key] = value
  }
  return dict
}

/// Unpacks one MessagePackValue from `data` at `offset`, advancing `offset`.
func unpackValue(
  _ data: Data,
  offset: inout Int,
  compatibility: Bool
) throws -> MessagePackValue {
  let byte = try unpackByte(data, offset: &offset)

  switch byte {
  // positive fixint
  case 0x00...0x7F:
    return .uint(UInt64(byte))

  // fixmap
  case 0x80...0x8F:
    let count = Int(byte - 0x80)
    return .map(try unpackMap(data, offset: &offset, count: count, compatibility: compatibility))

  // fixarray
  case 0x90...0x9F:
    let count = Int(byte - 0x90)
    return .array(
      try unpackArray(data, offset: &offset, count: count, compatibility: compatibility))

  // fixstr
  case 0xA0...0xBF:
    let count = Int(byte - 0xA0)
    if compatibility {
      return .binary(try unpackData(data, offset: &offset, count: count))
    } else {
      return .string(try unpackString(data, offset: &offset, count: count))
    }

  // nil
  case 0xC0:
    return .nil

  // false
  case 0xC2:
    return .bool(false)

  // true
  case 0xC3:
    return .bool(true)

  // bin 8, 16, 32
  case 0xC4...0xC6:
    let intCount = 1 << Int(byte - 0xC4)
    let dataCount = Int(try unpackInteger(data, offset: &offset, count: intCount))
    return .binary(try unpackData(data, offset: &offset, count: dataCount))

  // ext 8, 16, 32
  case 0xC7...0xC9:
    let intCount = 1 << Int(byte - 0xC7)
    let dataCount = Int(try unpackInteger(data, offset: &offset, count: intCount))
    let type = Int8(bitPattern: try unpackByte(data, offset: &offset))
    return .extended(type, try unpackData(data, offset: &offset, count: dataCount))

  // float 32
  case 0xCA:
    let intValue = try unpackInteger(data, offset: &offset, count: 4)
    return .float(Float(bitPattern: UInt32(truncatingIfNeeded: intValue)))

  // float 64
  case 0xCB:
    let intValue = try unpackInteger(data, offset: &offset, count: 8)
    return .double(Double(bitPattern: intValue))

  // uint 8, 16, 32, 64
  case 0xCC...0xCF:
    let count = 1 << (Int(byte) - 0xCC)
    return .uint(try unpackInteger(data, offset: &offset, count: count))

  // int 8
  case 0xD0:
    let b = Int8(bitPattern: try unpackByte(data, offset: &offset))
    return .int(Int64(b))

  // int 16
  case 0xD1:
    let bytes = try unpackInteger(data, offset: &offset, count: 2)
    return .int(Int64(Int16(bitPattern: UInt16(truncatingIfNeeded: bytes))))

  // int 32
  case 0xD2:
    let bytes = try unpackInteger(data, offset: &offset, count: 4)
    return .int(Int64(Int32(bitPattern: UInt32(truncatingIfNeeded: bytes))))

  // int 64
  case 0xD3:
    let bytes = try unpackInteger(data, offset: &offset, count: 8)
    return .int(Int64(bitPattern: bytes))

  // fixext 1, 2, 4, 8, 16
  case 0xD4...0xD8:
    let count = 1 << Int(byte - 0xD4)
    let type = Int8(bitPattern: try unpackByte(data, offset: &offset))
    return .extended(type, try unpackData(data, offset: &offset, count: count))

  // str 8, 16, 32
  case 0xD9...0xDB:
    let countSize = 1 << Int(byte - 0xD9)
    let count = Int(try unpackInteger(data, offset: &offset, count: countSize))
    if compatibility {
      return .binary(try unpackData(data, offset: &offset, count: count))
    } else {
      return .string(try unpackString(data, offset: &offset, count: count))
    }

  // array 16, 32
  case 0xDC...0xDD:
    let countSize = 1 << Int(byte - 0xDB)
    let count = Int(try unpackInteger(data, offset: &offset, count: countSize))
    return .array(
      try unpackArray(data, offset: &offset, count: count, compatibility: compatibility))

  // map 16, 32
  case 0xDE...0xDF:
    let countSize = 1 << Int(byte - 0xDD)
    let count = Int(try unpackInteger(data, offset: &offset, count: countSize))
    return .map(try unpackMap(data, offset: &offset, count: count, compatibility: compatibility))

  // negative fixint
  case 0xE0...0xFF:
    return .int(Int64(byte) - 0x100)

  default:
    throw MessagePackError.invalidData
  }
}

/// Unpacks data into a MessagePackValue and returns the remaining data.
///
/// - parameter data: The input data to unpack.
/// - parameter compatibility: When true, unpacks strings as binary data.
///
/// - returns: A `MessagePackValue` and the not-unpacked remaining data.
public func unpack(
  _ data: Data,
  compatibility: Bool = false
) throws -> (value: MessagePackValue, remainder: Data) {
  var offset = data.startIndex
  let value = try unpackValue(data, offset: &offset, compatibility: compatibility)
  return (value, data[offset..<data.endIndex])
}

/// Unpacks a data object into a `MessagePackValue`, ignoring excess data.
///
/// - parameter data: The data to unpack.
/// - parameter compatibility: When true, unpacks strings as binary data.
///
/// - returns: The contained `MessagePackValue`.
public func unpackFirst(_ data: Data, compatibility: Bool = false) throws -> MessagePackValue {
  var offset = data.startIndex
  return try unpackValue(data, offset: &offset, compatibility: compatibility)
}

/// Unpacks a data object into an array of `MessagePackValue` values.
///
/// - parameter data: The data to unpack.
/// - parameter compatibility: When true, unpacks strings as binary data.
///
/// - returns: The contained `MessagePackValue` values.
public func unpackAll(_ data: Data, compatibility: Bool = false) throws -> [MessagePackValue] {
  var values = [MessagePackValue]()
  var offset = data.startIndex
  while offset < data.endIndex {
    values.append(try unpackValue(data, offset: &offset, compatibility: compatibility))
  }
  return values
}
