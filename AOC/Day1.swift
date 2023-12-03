import Foundation

// Challenge: one-expression pipeline without `let` and control statements like `if`, `return`, etc.
// Basically, no keywords except `in`.

struct Day1: Day {
    let lines: [Substring]

    init(_ input: String) {
        self.lines = input.split(whereSeparator: \.isNewline)
    }

    func part1() -> Int {
        lines
            .reduce(0) { partialResult, line in
                partialResult
                    + 10 * Int(defaultingToZero: line.first(where: \.isNumber))
                    + Int(defaultingToZero: line.last(where: \.isNumber))
            }
    }

    func part2() -> Int {
        lines
            .reduce(0) { (partialResult: Int, line: String.SubSequence) -> Int in
                partialResult
                    + (line
                    .enumerated()
                    .filter(\.element.isNumber)
                    .map { range in
                        (offset: range.offset, element: Int(defaultingToZero: range.element))
                    }
                    + ["\u{0000}", "one", "two", "three", "four", "five", "six", "seven", "eight", "nine"]
                    .enumerated()
                    .map { digit, word in
                        line.ranges(of: word).map { range in
                            (offset: range.lowerBound.utf16Offset(in: line), element: digit)
                        }
                    }
                    .joined())
                    .sorted(by: \.offset)
                    .map(\.element)
                    .reduce(into: []) { result, current in
                        result = [result.first ?? current, current]
                    }
                    .reduce(0) { first, last in
                        first * 10 + last
                    }
            }
    }
}
