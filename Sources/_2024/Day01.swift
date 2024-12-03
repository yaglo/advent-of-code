// MARK: Day 1: Historian Hysteria -

import AdventOfCode
import Foundation

struct Day01: AdventDay {
  // MARK: -

  func part1() -> Int {
    zip(l1.sorted(), l2.sorted()).reduce(0) { $0 + abs($1.0 - $1.1) }
  }

  func part2() -> Int {
    let nums = NSCountedSet(array: l2)
    return l1.reduce(0) { $0 + $1 * nums.count(for: $1) }
  }

  // MARK: - Data

  let l1: [Int]
  let l2: [Int]

  init(data: String) {
    let input = data.mapLines { $0.integers(separatedBy: "   ") }
    l1 = input.map { $0[0] }
    l2 = input.map { $0[1] }
  }
}
