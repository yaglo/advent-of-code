import Algorithms
import Collections
import Numerics

// MARK: - Sequences and Collections

extension Sequence {
  func max<Value: Comparable>(_ keyPath: KeyPath<Self.Element, Value>) -> Value? {
    self.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })?[keyPath: keyPath]
  }

  func min<Value: Comparable>(_ keyPath: KeyPath<Self.Element, Value>) -> Value? {
    self.min(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })?[keyPath: keyPath]
  }

  func sorted<Value: Comparable>(by keyPath: KeyPath<Self.Element, Value>) -> [Self.Element] {
    self.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
  }

  func sum() -> Element where Element: AdditiveArithmetic {
    self.reduce(Element.zero, +)
  }

  func sum<Value: AdditiveArithmetic>(of keyPath: KeyPath<Self.Element, Value>) -> Value {
    self.map { $0[keyPath: keyPath] }.sum()
  }

  func product() -> Element where Element: Numeric {
    self.reduce(1, *)
  }

  func product<Value: Numeric>(of keyPath: KeyPath<Self.Element, Value>) -> Value {
    self.map { $0[keyPath: keyPath] }.product()
  }
}

extension Collection {
  @inlinable func reduce(
    with nextPartialResult: (Element, Element) throws -> Element
  ) rethrows -> Element {
    try dropFirst().reduce(first!, nextPartialResult)
  }
}

extension BidirectionalCollection {
  func mapPairs<T>(_ transform: (Element, Element) throws -> T) rethrows -> [T] {
    precondition(count.isMultiple(of: 2))

    return try chunks(ofCount: 2).map {
      try transform($0.first!, $0.last!)
    }
  }
}

// MARK: - Ranges

extension Substring {
  func closedRange(from range: Range<Substring.Index>) -> ClosedRange<Int> {
    distance(from: startIndex, to: range.lowerBound)...distance(
      from: startIndex,
      to: range.upperBound
    ) - 1
  }
}

extension Range {
  func intersection(with other: Range) -> Range {
    Swift.max(lowerBound, other.lowerBound)..<Swift.min(upperBound, other.upperBound)
  }
}

// MARK: - Numbers

infix operator ~~
extension Double {
  static func ~~ (lhs: Double, rhs: Double) -> Bool {
    return abs(lhs - rhs) < 0.00001
  }

  var isWhole: Bool {
    remainder(dividingBy: 1) ~~ 0
  }
}

// MARK: - Splatting

extension Array {
  func splat() -> (Element, Element) {
    return (self[0], self[1])
  }

  func splat() -> (Element, Element, Element) {
    return (self[0], self[1], self[2])
  }

  func splat() -> (Element, Element, Element, Element) {
    return (self[0], self[1], self[2], self[3])
  }

  func splat() -> (Element, Element, Element, Element, Element) {
    return (self[0], self[1], self[2], self[3], self[4])
  }

  func splat<T>(_ transform: (Element, Element) throws -> T) rethrows -> T {
    try transform(self[0], self[1])
  }

  func splat<T>(_ transform: (Element, Element, Element) throws -> T) rethrows -> T {
    try transform(self[0], self[1], self[2])
  }

  func splat<T>(_ transform: (Element, Element, Element, Element) throws -> T) rethrows -> T {
    try transform(self[0], self[1], self[2], self[3])
  }

  func splat<T>(_ transform: (Element, Element, Element, Element, Element) throws -> T) rethrows
    -> T
  {
    try transform(self[0], self[1], self[2], self[3], self[4])
  }
}

// MARK: - Parsing and Conversion

extension Int {
  init(_ c: Character?) {
    if let c {
      self = Int(String(c)) ?? 0
    } else {
      self = 0
    }
  }
}

extension BidirectionalCollection where Self.SubSequence == Substring {
  func integers(separatedBy separator: String) -> [Int] {
    split(separator: separator).map { Int($0)! }
  }
}

extension String {
  @inlinable
  func lines() -> [Substring] {
    split(whereSeparator: \.isNewline)
  }

  func mapLines<T>(_ transform: (Substring) throws -> T) rethrows -> [T] {
    try lines().map(transform)
  }
}

extension Substring {
  @inlinable
  func lines() -> [Substring] {
    split(whereSeparator: \.isNewline)
  }
}

extension LazySequence<String> {
  @inlinable
  func lines() -> SplitCollection<Elements> {
    split(whereSeparator: \.isNewline)
  }
}

// MARK: - Concurrency

extension Sequence {
  func parallelMapReduce<T, V>(_ initialResult: V, map: @escaping (Element) throws -> T, reduce: (V, T) throws -> V) async rethrows -> V {
    try await withThrowingTaskGroup(of: T.self, returning: V.self) { group in
      for element in self {
        group.addTask {
          try map(element)
        }
      }
      return try await group.reduce(initialResult, reduce)
    }
  }
}
