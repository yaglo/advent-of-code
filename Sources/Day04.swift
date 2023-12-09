// Challenge(?): Not using 2D data structures.

struct Day04: AdventDay {
  // MARK: -

  func part1() -> Int {
    scores
      .map { 2 << ($0 - 2) }
      .sum()
  }

  func part2() -> Int {
    var cardCounts = [Int](repeating: 1, count: scores.count)
    for (index, score) in scores.enumerated() where score > 0 {
      for bonusCardIndex in index + 1...index + score {
        cardCounts[bonusCardIndex] += cardCounts[index]
      }
    }
    return cardCounts.sum()
  }

  // MARK: - Data

  let scores: [Int]

  init(data: String) {
    scores = data.mapLines { line in
      let numbers =
        line
        .drop { $0 != ":" }
        .dropFirst()
        .split(separator: "|")
        .map { $0.split(separator: " ") }
        .map { Set($0.map { Int($0)! }) }
      return numbers[0].intersection(numbers[1]).count
    }
  }
}
