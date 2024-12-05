// MARK: Day 1: Sonar Sweep -

import AdventOfCode

struct Day01: AdventDay {
  // MARK: -

  func part1() -> Int { zip(lines, lines.dropFirst()).count(where: <) }

  func part2() -> Int { zip(lines, lines.dropFirst(3)).count(where: <) }

  // MARK: - Data

  let lines: [Int]

  init(data: String) { self.lines = data.integers(separatedBy: "\n") }
}
