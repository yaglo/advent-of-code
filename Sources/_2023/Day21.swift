// MARK: Day 21: Step Counter -

import AdventOfCode
import Collections

struct Day21: AdventDay {
  // MARK: -

  struct Coordinate: Equatable, Hashable { let row, column: Int }

  func part1() -> Int { findPossibleSteps(grid, maxSteps: 64).joined().filter { $0 }.count }

  func part2() -> Int {
    let mult = 7
    let side = grid.count
    let grid = Array(grid.map { Array($0.cycled(times: mult)) }.cycled(times: mult))
    let possibleSteps = findPossibleSteps(grid, maxSteps: grid.count / 2)
    var c = [[Int]](repeating: [Int](repeating: 0, count: mult), count: mult)

    for row in 0..<mult {
      for column in 0..<mult {
        c[row][column] = possibleSteps[row * side..<(row + 1) * side]
          .map { $0[column * side..<(column + 1) * side].reduce(0) { $1 ? $0 + 1 : $0 } }.sum()
      }
    }

    let n = (((26_501_365 * 2 + 1) / side) - 1) / 2

    return [
      c[3][0], c[0][3], c[6][3], c[3][6], n * n * c[1][3], (n - 1) * (n - 1) * c[2][3],
      n * [c[0][2], c[0][4], c[6][2], c[6][4]].sum(),
      (n - 1) * [c[1][2], c[1][4], c[5][2], c[5][4]].sum(),
    ]
    .sum()
  }

  func findPossibleSteps(_ grid: [[Bool]], maxSteps: Int) -> [[Bool]] {
    var steps = [[Bool]](
      repeating: [Bool](repeating: false, count: grid[0].count),
      count: grid.count
    )
    let start = Coordinate(row: grid.count / 2, column: grid.count / 2)

    func mark(steps: inout [[Bool]], from c: Coordinate) -> [Coordinate] {
      [(-1, 0), (1, 0), (0, -1), (0, 1)]
        .compactMap { dr, dc in
          let c = Coordinate(row: c.row + dr, column: c.column + dc)
          guard c.column >= 0 && c.column < steps[0].count && c.row >= 0 && c.row < steps.count,
            grid[c.row][c.column], !steps[c.row][c.column]
          else { return nil }
          steps[c.row][c.column] = true
          return c
        }
    }

    _ = (0..<maxSteps)
      .reduce([start]) { coordinates, _ in coordinates.flatMap { mark(steps: &steps, from: $0) } }

    return steps.enumerated()
      .map { r, line in
        line.enumerated()
          .map { c, valid in valid && ((r % 2 == 1 && c % 2 == 1) || (r % 2 == 0 && c % 2 == 0)) }
      }
  }

  let grid: [[Bool]]

  init(data: String) { grid = data.lines().map { $0.map { $0 != "#" } } }
}
