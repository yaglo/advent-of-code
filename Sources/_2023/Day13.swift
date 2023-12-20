// MARK: Day 13: Point of Incidence -

import AdventOfCode
import Algorithms

struct Day13: AdventDay {
  // MARK: -

  func part1() -> Int {
    let maps = data.split(separator: "\n\n")
      .map { $0.split(separator: "\n").map { $0.map { $0 == "." ? 0 : 1 } } }

    var sum = 0

    for map in maps {
      for row in map {
        for item in row { print(item == 0 ? "." : "#", terminator: "") }
        print()
      }
      print()

      var size = map[0].count
      column: for width in stride(from: size / 2, through: 1, by: -1) {
        for offset in [0, size - width * 2] {
          var left: [[Int]] = []
          var right: [[Int]] = []

          for column in 0..<width {
            left.append(map[column: column + offset])
            right.append(map[column: offset + width * 2 - 1 - column])
          }

          if left == right {
            sum += offset + width
            break column
          }
        }
      }

      size = map.count
      row: for width in stride(from: size / 2, through: 1, by: -1) {
        for offset in [0, size - width * 2] {
          var top: [[Int]] = []
          var bottom: [[Int]] = []

          for row in 0..<width {
            top.append(map[row + offset])
            bottom.append(map[offset + width * 2 - 1 - row])
          }

          if top == bottom {
            sum += (offset + width) * 100
            break row
          }
        }
      }
    }
    return sum
  }

  func part2() -> Int { 0 }

  // MARK: - Data

  let data: String
}
