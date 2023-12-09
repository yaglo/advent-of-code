// MARK: Day 4: Scratchcards -

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
      line
        .drop { $0 != ":" }
        .dropFirst()
        .split(separator: "|")
        .map { $0.integers(separatedBy: " ") }
        .map(Set.init)
        .splat { $0.intersection($1).count }
    }
  }
}
