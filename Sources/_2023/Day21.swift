// MARK: Day 21: Step Counter -

import AdventOfCode
import Collections

struct Day21: AdventDay {
  // MARK: -

  func part1() -> Int {
    var grid = grid
    findPossibleSteps(&grid, maxSteps: 64)
    return grid.joined().filter { $0 == 1 }.count
  }

  func part2() -> Int {
    let mult = 7
    let side = grid.count
    var grid = Array(grid.map { Array($0.cycled(times: mult)) }.cycled(times: mult))
    findPossibleSteps(&grid, maxSteps: grid.count / 2)
    var c = [[Int]](repeating: [Int](repeating: 0, count: mult), count: mult)
    let n = (((26_501_365 * 2 + 1) / side) - 1) / 2

    for row in 0..<mult {
      for col in 0..<mult {
        c[row][col] = grid[row * side..<(row + 1) * side]
          .map { $0[col * side..<(col + 1) * side].reduce(0) { $1 == 1 ? $0 + 1 : $0 } }.sum()
      }
    }

    return [
      c[3][0], c[0][3], c[6][3], c[3][6], n * n * c[1][3], (n - 1) * (n - 1) * c[2][3],
      (n - 1) * [c[1][2], c[1][4], c[5][2], c[5][4]].sum(),
      n * [c[0][2], c[0][4], c[6][2], c[6][4]].sum(),
    ]
    .sum()
  }

  func findPossibleSteps(_ grid: inout [[Int8]], maxSteps: Int) {
    let side = grid.count
    let start = (side / 2, side / 2)

    typealias Coordinate = (row: Int, column: Int)

    var queue: Deque<(Coordinate, Int)> = [(start, 0)]
    while let step = queue.popFirst() {
      guard step.1 < maxSteps else { continue }
      for dir in [(-1, 0), (1, 0), (0, -1), (0, 1)] {
        let c = (row: step.0.row + dir.0, column: step.0.column + dir.1)
        guard c.column >= 0 && c.column < side && c.row >= 0 && c.row < side,
          grid[c.row][c.column] == 0
        else { continue }
        if (c.row + c.column) % 2 == 0 { grid[c.row][c.column] = 1 }
        queue.append((c, step.1 + 1))
      }
    }
  }

  let grid: [[Int8]]

  init(data: String) { grid = data.lines().map { $0.map { $0 == "#" ? -1 : 0 } } }
}
