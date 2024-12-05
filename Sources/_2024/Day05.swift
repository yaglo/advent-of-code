// MARK: Day 5: Print Queue -

import AdventOfCode

struct Day05: AdventDay {
  // MARK: -

  func part1() -> Int { updates.filter(isValid).sum { $0[$0.count / 2] } }

  func part2() -> Int {
    updates
      .filter { !isValid($0) }
      .map { $0.sorted(by: { precedence[$0][$1] }) }
      .sum { $0[$0.count / 2] }
  }

  func isValid(_ update: [Int]) -> Bool {
    update.indices.allSatisfy { i in
      (i + 1..<update.count).allSatisfy { j in
        precedence[update[i]][update[j]]
      }
    }
  }

  // MARK: - Data

  let updates: [[Int]]
  let precedence: [[Bool]]

  init(data: String) {
    let (r, u) = data.split(separator: "\n\n").splat()
    let rules: [(Int, Int)] = r.lines().map { $0.integers(separatedBy: "|").splat() }

    updates = u.lines().map { $0.integers(separatedBy: ",") }

    let maxPageNumber =
      max(rules.flatMap { [$0.0, $0.1] }.max() ?? 0, updates.flatMap { $0 }.max() ?? 0) + 1

    var precedence = Array(
      repeating: Array(repeating: false, count: maxPageNumber), count: maxPageNumber)

    for rule in rules { precedence[rule.0][rule.1] = true }

    self.precedence = precedence
  }
}
