// MARK: Day 1: Calorie Counting -

import AdventOfCode

struct Day01: AdventDay {
  // MARK: -

  func part1() -> Int { calculateCaloriesPerElf().max()! }

  func part2() -> Int { calculateCaloriesPerElf().sorted(by: >).prefix(3).sum() }

  func calculateCaloriesPerElf() -> [Int] {
    data.split(separator: "\n\n").map { String($0).lines().sum { Int($0)! } }
  }

  // MARK: - Data

  let data: String
}
