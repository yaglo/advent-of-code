// MARK: Day 4: Scratchcards -

import AdventOfCode
import RegexBuilder

struct Day04: AdventDay {
  // MARK: -

  func part1() -> Int { scores.map { 2 << ($0 - 2) }.sum() }

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
    let cardRegex = Regex {
      /Card.*:\s+/
      Capture.setOfIntegers
      /\s+\|\s+/
      Capture.setOfIntegers
    }
    scores = data.mapLines { line in
      let (_, winning, mine) = line.firstMatch(of: cardRegex)!.output
      return winning.intersection(mine).count
    }
  }
}
