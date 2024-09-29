import Foundation

public struct Subdata: RandomAccessCollection {
  let base: Data
  let baseStartIndex: Int
  let baseEndIndex: Int

  public init(data: Data, startIndex: Int = 0) {
    self.init(data: data, startIndex: startIndex, endIndex: data.endIndex)
  }

  public init(data: Data, startIndex: Int, endIndex: Int) {
    self.base = data
    self.baseStartIndex = startIndex
    self.baseEndIndex = endIndex
  }

  public var startIndex: Int {
    0
  }

  public var endIndex: Int {
    self.baseEndIndex - self.baseStartIndex
  }

  public var count: Int {
    self.endIndex - self.startIndex
  }

  public var isEmpty: Bool {
    self.baseStartIndex == self.baseEndIndex
  }

  public subscript(index: Int) -> UInt8 {
    self.base[self.baseStartIndex + index]
  }

  public func index(before i: Int) -> Int {
    i - 1
  }

  public func index(after i: Int) -> Int {
    i + 1
  }

  public subscript(bounds: Range<Int>) -> Subdata {
    precondition(self.baseStartIndex + bounds.upperBound <= self.baseEndIndex)
    return Subdata(
      data: self.base,
      startIndex: self.baseStartIndex + bounds.lowerBound,
      endIndex: self.baseStartIndex + bounds.upperBound
    )
  }

  public var data: Data {
    self.base.subdata(in: self.baseStartIndex..<self.baseEndIndex)
  }
}
