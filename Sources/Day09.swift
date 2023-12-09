// MARK: Day 9: Mirage Maintenance -

import Algorithms

struct Day09: AdventDay {
  // MARK: -

  func part1() -> Int {
    sequences.map { sequence in
      extrapolateLastElement(sequence: sequence)
    }
    .sum()
  }

  func part2() -> Int {
    sequences.map { sequence in
      extrapolateLastElement(sequence: sequence.reversed())
    }
    .sum()
  }

  // MARK: - Helpers

  func extrapolateLastElement(sequence: [Int]) -> Int {
    var lastElements = [sequence.last!]

    var diffs = sequence
    while diffs.contains(where: { $0 != 0 }) {
      diffs = differences(sequence: diffs)
      lastElements.append(diffs.last!)
    }

    return lastElements.sum()
  }

  func differences(sequence: [Int]) -> [Int] {
    zip(sequence, sequence.dropFirst()).map { $1 - $0 }
  }

  // MARK: - Data

  let sequences: [[Int]]

  init(data: String) {
    sequences = data.mapLines { line in
      line.split(separator: " ").map { Int($0)! }
    }
  }
}
