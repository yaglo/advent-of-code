// MARK: Day 6: Guard Gallivant -

import AdventOfCode
import Collections

struct Day06: AdventDay {
  // MARK: - Part 1 and Part 2

  func part1() -> Int {
    simulatePath().count
  }

  func part2() -> Int {
    simulatePath().count {
      guardWouldLoop(obstacleCoordinate: $0)
    }
  }

  func simulatePath() -> [Coordinate] {
    var currentDirection = Direction.up
    var currentCoordinate = startingCoordinate
    var visited = Array(repeating: false, count: grid.count * grid[0].count)

    visited[currentCoordinate.row * grid[0].count + currentCoordinate.column] = true

    while true {
      let delta = currentDirection.delta
      let nextRow = currentCoordinate.row + delta.row
      let nextColumn = currentCoordinate.column + delta.column

      if nextRow < 0 || nextRow >= grid.count || nextColumn < 0 || nextColumn >= grid[0].count {
        break
      }

      if grid[nextRow][nextColumn] {
        currentDirection.turnRight()
      } else {
        currentCoordinate.row = nextRow
        currentCoordinate.column = nextColumn
        visited[currentCoordinate.row * grid[0].count + currentCoordinate.column] = true
      }
    }

    return visited.indices.compactMap {
      visited[$0] ? Coordinate(row: $0 / grid[0].count, column: $0 % grid[0].count) : nil
    }
  }

  func guardWouldLoop(obstacleCoordinate: Coordinate) -> Bool {
    var currentDirection: Direction = .up
    var currentCoordinate = startingCoordinate
    let gridWidth = grid[0].count
    var visited: [UInt8] = Array(repeating: 0, count: grid.count * gridWidth)

    func directionBit(_ direction: Direction) -> UInt8 {
      switch direction {
      case .up: 1 << 0  // 0001
      case .right: 1 << 1  // 0010
      case .down: 1 << 2  // 0100
      case .left: 1 << 3  // 1000
      }
    }

    @inline(__always)
    func recordVisit() -> Bool {
      let index = currentCoordinate.row * gridWidth + currentCoordinate.column
      let bit = directionBit(currentDirection)

      // Already visited - loop!
      if visited[index] & bit != 0 {
        return true
      }

      visited[index] |= bit

      return false
    }

    while true {
      if recordVisit() {
        return true
      }

      let delta = currentDirection.delta
      let nextRow = currentCoordinate.row + delta.row
      let nextColumn = currentCoordinate.column + delta.column

      if nextRow < 0 || nextRow >= grid.count || nextColumn < 0 || nextColumn >= gridWidth {
        return false
      }

      if grid[nextRow][nextColumn]
        || Coordinate(row: nextRow, column: nextColumn) == obstacleCoordinate
      {
        currentDirection.turnRight()
      } else {
        currentCoordinate.row = nextRow
        currentCoordinate.column = nextColumn
      }
    }
  }

  // MARK: - Data

  let grid: [[Bool]]
  let startingCoordinate: Coordinate

  init(data: String) {
    var startingCoordinate: Coordinate?

    grid = data.lines().enumerated().map { y, line in
      line.enumerated().map { x, char in
        if char == "^" {
          startingCoordinate = Coordinate(row: y, column: x)
        }
        return char == "#"
      }
    }

    self.startingCoordinate = startingCoordinate!
  }
}
