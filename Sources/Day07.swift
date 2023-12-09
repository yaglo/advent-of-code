// MARK: Day 7: Camel Cards -

import Algorithms
import Foundation

struct Day07: AdventDay {
  // MARK: -

  func part1() -> Int {
    solve(withJokers: false)
  }

  func part2() -> Int {
    solve(withJokers: true)
  }

  // MARK: - Helpers

  func solve(withJokers: Bool) -> Int {
    data
      .mapLines { line in
        line
          .split(separator: " ")
          .splat { Game(String($0), bid: Int($1)!, withJokers: withJokers) }
      }
      .sorted()
      .enumerated()
      .map { ($0.offset + 1) * $0.element.bid }
      .sum()
  }

  // MARK: - Data

  let data: String

  // MARK: - Models

  enum HandType: Int, Comparable {
    case fiveOfAKind, fourOfAKind, fullHouse, threeOfAKind, twoPair, onePair, highCard

    init(counts: [Int]) {
      self =
        switch counts {
        case [5]: .fiveOfAKind
        case [4, 1]: .fourOfAKind
        case [3, 2]: .fullHouse
        case [3, 1, 1]: .threeOfAKind
        case [2, 2, 1]: .twoPair
        case [2, 1, 1, 1]: .onePair
        case [1, 1, 1, 1, 1]: .highCard
        default: fatalError()
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.rawValue > rhs.rawValue
    }
  }

  enum Card: Comparable {
    case number(Int)
    case joker, jack, queen, king, ace

    var value: Int {
      switch self {
      case .joker: 1
      case .number(let int): int
      case .jack: 11
      case .queen: 12
      case .king: 13
      case .ace: 14
      }
    }

    init(_ character: Character) {
      self =
        switch character {
        case "T": .number(10)
        case "J": .jack
        case "Q": .queen
        case "K": .king
        case "A": .ace
        default: .number(Int(String(character))!)
        }
    }

    static func < (lhs: Self, rhs: Self) -> Bool {
      lhs.value < rhs.value
    }
  }

  struct Game: Comparable {
    let hand: [Card]
    let bid: Int
    let type: HandType

    init(_ string: String, bid: Int, withJokers: Bool) {
      self.bid = bid

      self.hand = string.map {
        if $0 == "J" {
          withJokers ? .joker : .jack
        } else {
          Card($0)
        }
      }

      var cards = hand
        .sorted()
        .chunked(by: ==)
        .sorted { $0.count > $1.count }

      if withJokers, cards.count > 1,
        let jokers = cards.firstIndex(where: { $0.contains(.joker) })
      {
        cards[0].append(contentsOf: cards.remove(at: jokers))
      }

      type = .init(counts: cards.map(\.count))
    }

    static func < (lhs: Game, rhs: Game) -> Bool {
      if lhs.type == rhs.type {
        for index in lhs.hand.indices where lhs.hand[index] != rhs.hand[index] {
          return lhs.hand[index] < rhs.hand[index]
        }
      }
      return lhs.type < rhs.type
    }
  }
}
