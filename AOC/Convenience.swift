//
//  Helpers.swift
//  AOC
//
//  Created by Stanislav Yaglo on 03/12/2023.
//

import Foundation

protocol Day {
    associatedtype Result
    init(_ input: String)
    func part1() -> Result
    func part2() -> Result
}

extension Sequence {
    func max<Value: Comparable>(_ keyPath: KeyPath<Self.Element, Value>) -> Value? {
        self.max(by: { $0[keyPath: keyPath] < $1[keyPath: keyPath] })?[keyPath: keyPath]
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

extension Int {
    init(defaultingToZero c: Character?) {
        if let c {
            self = Int(String(c)) ?? 0
        } else {
            self = 0
        }
    }
}

extension Substring {
    func closedRange(from range: Range<Substring.Index>) -> ClosedRange<Int> {
        distance(from: startIndex, to: range.lowerBound)...distance(from: startIndex, to: range.upperBound)
    }
}
