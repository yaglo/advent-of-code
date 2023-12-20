// MARK: Day 3: Gear Ratios -

import AdventOfCode

/// Challenge(?): Not using 2D data structures.

struct Day03: AdventDay {
  // MARK: -

  func part1() -> Int {
    numbers.filter { number in parts.contains { $0.rect.overlaps(number.rect) } }.sum(of: \.value)
  }

  func part2() -> Int {
    parts.compactMap { part -> Int? in
      guard part.type == "*" else { return nil }
      let numbers = numbers.filter { part.rect.overlaps($0.rect) }
      guard numbers.count == 2 else { return nil }
      return numbers.product(of: \.value)
    }
    .sum()
  }

  // MARK: - Data

  let numbers: [Number]
  let parts: [PartSymbol]

  init(data: String) {
    let lines = data.lines()

    numbers = lines.enumerated()
      .flatMap { y, line in
        line.matches(of: /\d+/)
          .map { match in
            Number(
              rect: .init(x: line.closedRange(from: match.range), y: y...y),
              value: Int(match.output)!
            )
          }
      }

    parts = lines.enumerated()
      .flatMap { y, line in
        line.matches(of: /[^.0-9]/)
          .map { match in
            let range = line.closedRange(from: match.range)
            return PartSymbol(
              rect: .init(x: range.lowerBound - 1...range.upperBound + 1, y: (y - 1)...(y + 1)),
              type: String(match.output)
            )
          }
      }
  }

  // MARK: - Models

  struct Rectangle {
    let x: ClosedRange<Int>
    let y: ClosedRange<Int>

    func overlaps(_ other: Rectangle) -> Bool { x.overlaps(other.x) && y.overlaps(other.y) }
  }

  struct Number {
    let rect: Rectangle
    let value: Int
  }

  struct PartSymbol {
    let rect: Rectangle
    let type: String
  }
}
