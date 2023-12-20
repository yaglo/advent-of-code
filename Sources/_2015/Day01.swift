// MARK: Day 1: Not Quite Lisp -

import AdventOfCode
import Foundation

struct Day01: AdventDay {
  // MARK: -

  func part1() -> Int {
    data.reduce(0) {
      switch $1 {
      case "(": $0 + 1
      case ")": $0 - 1
      default: $0
      }
    }
  }

  func part2() -> Int {
    var level = 0
    for (index, move) in data.enumerated() {
      switch move {
      case "(": level += 1
      case ")": level -= 1
      default: break
      }
      if level < 0 { return index + 1 }
    }
    fatalError()
  }

  // MARK: - Data

  let data: String

  init(data: String) { self.data = data.trimmingCharacters(in: .whitespacesAndNewlines) }
}
