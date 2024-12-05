// MARK: Day 5: Print Queue -

import AdventOfCode

struct Day05: AdventDay {
  // MARK: -

  func part1() -> Int { updates.filter(isValid).sum { $0[$0.count / 2] } }

  func part2() -> Int {
    updates
      .filter { !isValid($0) }
      .map { $0.sorted(by: { pagePrecedence[$0][$1] }) }
      .sum { $0[$0.count / 2] }
  }

  func isValid(_ update: [Int]) -> Bool {
    rules.allSatisfy { rule in
      guard let index1 = update.firstIndex(of: rule.0), let index2 = update.firstIndex(of: rule.1)
      else { return true }
      return index1 < index2
    }
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
