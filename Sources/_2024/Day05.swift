// MARK: Day 5:  -

import AdventOfCode
import Foundation

struct Day05: AdventDay {
  // MARK: -

  func part1() -> Int { updates.filter(isValid).sum { $0[$0.count / 2] } }

  func part2() -> Int {
    updates.sum { update in
      var update = update
      var wasInvalid = false

      while applyFixes(to: &update) { wasInvalid = true }

      return wasInvalid ? update[update.count / 2] : 0
    }
  }

  func isValid(_ update: [Int]) -> Bool {
    rules.allSatisfy { rule in
      guard let index1 = update.firstIndex(of: rule.0), let index2 = update.firstIndex(of: rule.1)
      else { return true }
      return index1 < index2
    }
  }

  func applyFixes(to update: inout [Int]) -> Bool {
    for (index, value) in update.enumerated() {
      for (otherIndex, otherValue) in update.enumerated()
      where (pagePrecedence[value][otherValue] && otherIndex < index)
        || (pagePrecedence[otherValue][value] && otherIndex > index)
      {
        update.swapAt(index, otherIndex)
        return true
      }
    }
    return false
  }

  // MARK: - Data

  let rules: [(Int, Int)]
  let updates: [[Int]]
  let pagePrecedence: [[Bool]]

  init(data: String) {
    let (r, u) = data.split(separator: "\n\n").splat()
    rules = r.lines().map { $0.integers(separatedBy: "|").splat() }
    updates = u.lines().map { $0.integers(separatedBy: ",") }

    let maxPageNumber =
      max(rules.flatMap { [$0.0, $0.1] }.max() ?? 0, updates.flatMap { $0 }.max() ?? 0) + 1

    var pagePrecedence = Array(
      repeating: Array(repeating: false, count: maxPageNumber), count: maxPageNumber)

    for rule in rules { pagePrecedence[rule.0][rule.1] = true }

    self.pagePrecedence = pagePrecedence
  }
}
