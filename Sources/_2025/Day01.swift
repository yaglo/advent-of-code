// MARK: Day 1: Secret Entrance -

import AdventOfCode

@Day struct Day01 {
  // MARK: -

  func part1() -> Int {
    var dial = 50
    return moves.count {
      dial = (dial + $0) %% 100
      return dial == 0
    }
  }

  func part2() -> Int {
    var dial = 50
    return moves.sum { move in
      defer { dial = (dial + move) %% 100 }
      return (dial * move.signum() %% 100 + abs(move)) / 100
    }
  }

  // MARK: - Data

  var moves: [Int] {
    data.mapLines { ($0.first == "L" ? -1 : 1) * Int($0.dropFirst())! }
  }
}
