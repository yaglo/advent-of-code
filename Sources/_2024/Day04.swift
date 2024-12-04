// MARK: Day 4 -

import AdventOfCode

struct Day04: AdventDay {
  // MARK: -

  func part1() -> Int {
    let directions = [(0, 1), (1, 0), (-1, 0), (0, -1), (1, 1), (-1, 1), (-1, -1), (1, -1)]
    let xmas = Array("XMAS")

    return grid.indices.sum { x in
      grid[x].indices.sum { y in
        directions.count { dx, dy in
          (0..<xmas.count).allSatisfy { i in
            grid[safe: x + i * dx]?[safe: y + i * dy] == xmas[i]
          }
        }
      }
    }
  }

  func part2() -> Int {
    let masOrSam = ["MAS", "SAM"]

    return (1..<grid.count - 1).sum { x in
      (1..<grid[0].count - 1).count { y in
        let tlbr = String([grid[x - 1][y - 1], grid[x][y], grid[x + 1][y + 1]])
        let trbl = String([grid[x + 1][y - 1], grid[x][y], grid[x - 1][y + 1]])
        return masOrSam.contains(tlbr) && masOrSam.contains(trbl)
      }
    }
  }

  // MARK: - Data

  let grid: [[Character]]

  init(data: String) {
    grid = data.lines().map(Array.init)
  }
}
