// MARK: Day 4: Ceres Search -

import AdventOfCode

struct Day04: AdventDay {
  // MARK: -

  func part1() -> Int {
    let directions = [(0, 1), (1, 0), (-1, 0), (0, -1), (1, 1), (-1, 1), (-1, -1), (1, -1)]
    let xmas = Array("XMAS")
    return grid.indices.sum { y in
      grid[y].indices.sum { x in
        directions.count { dy, dx in
          (0..<xmas.count).allSatisfy { i in
            grid[safe: y + i * dy]?[safe: x + i * dx] == xmas[i]
          }
        }
      }
    }
  }

  func part2() -> Int {
    let masOrSam = ["MAS", "SAM"]
    return (1..<grid.count - 1).sum { y in
      (1..<grid[y].count - 1).count { x in
        let tlbr = String([grid[y - 1][x - 1], grid[y][x], grid[y + 1][x + 1]])
        let bltr = String([grid[y + 1][x - 1], grid[y][x], grid[y - 1][x + 1]])
        return masOrSam.contains(tlbr) && masOrSam.contains(bltr)
      }
    }
  }

  // MARK: - Data

  let grid: [[Character]]

  init(data: String) {
    grid = data.mapLines(Array.init)
  }
}
