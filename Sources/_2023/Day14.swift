// MARK: Day 14: Parabolic Reflector Dish -

import AdventOfCode
import Foundation

struct Day14: AdventDay {
  // MARK: -

  func part1() -> Int {
    var map = parseMap()
    map.rotate(counterClockwise: true)
    rollWestwards(map: &map)
    map.rotate()
    return calculateLoad(map: map)
  }

  func part2() -> Int {
    var map = parseMap()

    func rotate4Times() {
      map.rotate(counterClockwise: true)
      for _ in 0..<4 {
        rollWestwards(map: &map)
        map.rotate()
      }
      map.rotate()
    }

    var seen = [Int: Int]()

    var cycledIterationAtBillion: Int? = nil

    for i in 0..<1_000_000_000 {
      rotate4Times()

      let hash = map.grid.hashValue
      if let x = seen[hash], cycledIterationAtBillion == nil {
        cycledIterationAtBillion = (1_000_000_000 - i) % (i - x) + i - 1
      }

      seen[hash] = i

      if cycledIterationAtBillion == i {
        return calculateLoad(map: map)
      }
    }
    fatalError()
  }

  func rollWestwards(map: inout Matrix) {
    map = Matrix(
      map.grid.chunks(ofCount: map.columns).map { line in
        let newLine = Array(
          line.split(omittingEmptySubsequences: false, whereSeparator: \.isSquareRock).map {
            let roundRocks = $0.filter { $0.isRoundRock }
            return roundRocks + Array(repeating: .empty, count: $0.count - roundRocks.count)
          })
        return Array(newLine.joined(by: .squareRock))
      })
  }

  func calculateLoad(map: Matrix) -> Int {
    var acc = 0
    for column in 0..<map.columns {
      for row in 0..<map.rows {
        acc += map[row, column].isRoundRock ? map.rows - row : 0
      }
    }
    return acc
  }

  // MARK: - Data

  let data: String

  func parseMap() -> Matrix {
    Matrix(
      data.split(whereSeparator: \.isNewline).map { line in
        line.map { item -> Double in
          switch item {
          case "#": .squareRock
          case "O": .roundRock
          default: .empty
          }
        }
      })
  }

  // MARK: - Models

  struct Counter {
    var lastStart: Int
    var currentCount: Int
    var accumulator: Int
  }
}

extension Double {
  fileprivate static var empty: Double { 0 }
  fileprivate var isEmpty: Bool { Int(self) == 0 }

  fileprivate static var squareRock: Double { 1 }
  fileprivate var isSquareRock: Bool { Int(self) == 1 }

  fileprivate static var roundRock: Double { 2 }
  fileprivate var isRoundRock: Bool { Int(self) == 2 }
}
