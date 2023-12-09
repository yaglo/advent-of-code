// MARK: Day 9: Mirage Maintenance -

import Algorithms

struct Day09: AdventDay {
  // MARK: -

  func part1() -> Int {
    sequences
      .map(extrapolateNextElement(in:))
      .sum()
  }

  func part2() -> Int {
    sequences.map { sequence in
      extrapolateNextElement(in: sequence.reversed())
    }
    .sum()
  }

  // MARK: - Helpers

  func extrapolateNextElement(in sequence: [Int]) -> Int {
    var lastElements = [sequence.last!]

    var diffs = sequence
    while diffs.contains(where: { $0 != 0 }) {
      diffs = zip(diffs.dropFirst(), diffs).map(-)
      lastElements.append(diffs.last!)
    }

    return lastElements.sum()
  }

  // MARK: - Data

  let sequences: [[Int]]

  init(data: String) {
    sequences = data.mapLines { $0.integers(separatedBy: " ") }
  }
}
