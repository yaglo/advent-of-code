// MARK: Day 1: Historian Hysteria -

import AdventOfCode

struct Day01: AdventDay {
  // MARK: -

  func part1() -> Int {
    zip(l1.sorted(), l2.sorted())
      .map(-)
      .map(abs)
      .sum()
  }

  func part2() -> Int {
    let nums = Dictionary(grouping: l2, by: \.self)
    return l1.map { $0 * (nums[$0]?.count ?? 0) }.sum()
  }

  // MARK: - Data

  let l1: [Int]
  let l2: [Int]

  init(data: String) {
    let input = data.mapLines(\.integers)
    l1 = input[column: 0]
    l2 = input[column: 1]
  }
}
