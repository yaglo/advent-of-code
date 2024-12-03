// MARK: Day 2: Red-Nosed Reports -

import AdventOfCode
import Foundation

struct Day02: AdventDay {
  // MARK: -

  func part1() -> Int {
    reports.count(where: isValid)
  }

  func part2() -> Int {
    reports.count { report in
      isValid(report) || report.indices.contains { index in
        isValid(report.removing(at: index))
      }
    }
  }

  private func isValid(_ levels: [Int]) -> Bool {
    zip(levels, levels.dropFirst())
      .map { abs($1 - $0) }
      .allSatisfy({ 1...3 ~= $0 })
    && (levels.isStrictlyIncreasing || levels.isStrictlyDecreasing)
  }

  // MARK: - Data

  let reports: [[Int]]

  init(data: String) {
    reports = data.mapLines { $0.integers(separatedBy: " ") }
  }
}
