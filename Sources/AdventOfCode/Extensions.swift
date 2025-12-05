import Algorithms
import Collections
import Numerics

// MARK: - Sequences and Collections

extension Sequence {
    public func max<Value: Comparable>(_ keyPath: KeyPath<Self.Element, Value>) -> Value? {
        self.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })?[keyPath: keyPath]
    }

    public func min<Value: Comparable>(_ keyPath: KeyPath<Self.Element, Value>) -> Value? {
        self.min(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })?[keyPath: keyPath]
    }

    public func sorted<Value: Comparable>(by keyPath: KeyPath<Self.Element, Value>) -> [Self.Element] {
        self.sorted { $0[keyPath: keyPath] < $1[keyPath: keyPath] }
    }

    public func sum() -> Element where Element: AdditiveArithmetic { self.reduce(Element.zero, +) }

    public func sum<Value: AdditiveArithmetic>(of keyPath: KeyPath<Self.Element, Value>) -> Value {
        self.map { $0[keyPath: keyPath] }.sum()
    }

    public func sum<Value: AdditiveArithmetic>(applying transform: (Element) -> Value) -> Value {
        self.map { transform($0) }.sum()
    }

    public func product() -> Element where Element: Numeric { self.reduce(1, *) }

    public func product<Value: Numeric>(of keyPath: KeyPath<Self.Element, Value>) -> Value {
        self.map { $0[keyPath: keyPath] }.product()
    }
}

extension Sequence where Element: Comparable {
    public var isStrictlyIncreasing: Bool { zip(self, dropFirst()).allSatisfy { $0 < $1 } }

    public var isStrictlyDecreasing: Bool { zip(self, dropFirst()).allSatisfy { $0 > $1 } }
}

extension RangeReplaceableCollection {
    public func removing(at index: Index) -> Self {
        var copy = self
        copy.remove(at: index)
        return copy
    }
}

extension Collection {
    @inlinable public func reduce(with nextPartialResult: (Element, Element) throws -> Element)
        rethrows -> Element
    {
        try dropFirst().reduce(first!, nextPartialResult)
    }
}

extension BidirectionalCollection {
    public func mapPairs<T>(_ transform: (Element, Element) throws -> T) rethrows -> [T] {
        precondition(count.isMultiple(of: 2))

        return try chunks(ofCount: 2).map { try transform($0.first!, $0.last!) }
    }
}

// MARK: - Ranges

extension Substring {
    public func closedRange(from range: Range<Substring.Index>) -> ClosedRange<Int> {
        distance(from: startIndex, to: range.lowerBound)...distance(
            from: startIndex, to: range.upperBound) - 1
    }
}

extension Range {
    public func intersection(with other: Range) -> Range {
        Swift.max(lowerBound, other.lowerBound)..<Swift.min(upperBound, other.upperBound)
    }
}

// MARK: - Numbers

infix operator ~~
extension Double {
    public static func ~~ (lhs: Double, rhs: Double) -> Bool { abs(lhs - rhs) < 0.00001 }

    public var isWhole: Bool { remainder(dividingBy: 1) ~~ 0 }
}

// MARK: - Splatting

extension Array {
    public func splat() -> (Element, Element) { (self[0], self[1]) }

    public func splat() -> (Element, Element, Element) { (self[0], self[1], self[2]) }

    public func splat() -> (Element, Element, Element, Element) {
        (self[0], self[1], self[2], self[3])
    }

    public func splat() -> (Element, Element, Element, Element, Element) {
        (self[0], self[1], self[2], self[3], self[4])
    }

    public func splat<T>(_ transform: (Element, Element) throws -> T) rethrows -> T {
        try transform(self[0], self[1])
    }

    public func splat<T>(_ transform: (Element, Element, Element) throws -> T) rethrows -> T {
        try transform(self[0], self[1], self[2])
    }

    public func splat<T>(_ transform: (Element, Element, Element, Element) throws -> T) rethrows -> T {
        try transform(self[0], self[1], self[2], self[3])
    }

    public func splat<T>(_ transform: (Element, Element, Element, Element, Element) throws -> T)
        rethrows -> T
    {
        try transform(self[0], self[1], self[2], self[3], self[4])
    }
}

// MARK: - Parsing and Conversion

extension Int {
    public init(_ c: Character?) { if let c { self = Int(String(c)) ?? 0 } else { self = 0 } }
}

extension BidirectionalCollection where Self.SubSequence == Substring {
    public func integers(separatedBy separator: String) -> [Int] {
        split(separator: separator).map { Int($0)! }
    }

    public var integers: [Int] { split(whereSeparator: \.isWhitespace).map { Int($0)! } }
}

extension StringProtocol where SubSequence == Substring {
    @inlinable public func lines() -> [Substring] { split(whereSeparator: \.isNewline) }

    public func mapLines<T>(_ transform: (Substring) throws -> T) rethrows -> [T] {
        try lines().map(transform)
    }
}

extension LazySequence<String> {
    @inlinable public func lines() -> SplitCollection<Elements> { split(whereSeparator: \.isNewline) }
}

// MARK: - Concurrency

extension Collection where Element: Sendable {
    public func parallelSum<Value: AdditiveArithmetic & Sendable>(
        chunkSize: Int = 1,
        applying transform: @escaping @Sendable (Element) throws -> Value
    ) async throws -> Value {
        if chunkSize == 1 {
            return try await withThrowingTaskGroup(of: Value.self, returning: Value.self) { group in
                for element in self {
                    group.addTask {
                        try transform(element)
                    }
                }
                return try await group.reduce(Value.zero, +)
            }
        } else {
            return try await withThrowingTaskGroup(of: Value.self, returning: Value.self) { group in
                for chunk in chunks(ofCount: chunkSize) {
                    let chunk = Array(chunk)
                    group.addTask {
                        var chunkSum = Value.zero
                        for element in chunk {
                            chunkSum += try transform(element)
                        }
                        return chunkSum
                    }
                }
                return try await group.reduce(Value.zero, +)
            }
        }
    }
}

//extension Sequence {
//  public func parallelMapReduce<T, V>(
//    _ initialResult: V,
//    map: @escaping (Element) throws -> T,
//    reduce: (V, T) throws -> V
//  ) async rethrows -> V {
//    try await withThrowingTaskGroup(of: T.self, returning: V.self) { group in
//      for element in self { group.addTask { try map(element) } }
//      return try await group.reduce(initialResult, reduce)
//    }
//  }
//}

extension Array where Element: Collection {
    public subscript(column column: Element.Index) -> [Element.Iterator.Element] {
        map { $0[column] }
    }
}

extension Collection {
    public subscript(safe index: Index) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}
