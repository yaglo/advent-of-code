// MARK: Day 17: Clumsy Crucible -

import AdventOfCode
import Collections
import Foundation

struct Day17: AdventDay {
  // MARK: -

  func part1() -> Int {
    findMinHeatLoss(
      grid: grid, precomputedHeatLoss: precomputeHeatLoss(grid: grid, stepRange: 1...3))
  }

  func part2() -> Int {
    findMinHeatLoss(
      grid: grid, precomputedHeatLoss: precomputeHeatLoss(grid: grid, stepRange: 4...10))
  }

  // MARK: - Helpers

  func precomputeHeatLoss(grid: [[Int]], stepRange: ClosedRange<Int>) -> LossMap {
    let rows = grid.count
    let columns = grid[0].count
    var precomputedLoss = LossMap()

    for row in 0..<rows {
      for column in 0..<columns {
        for direction in 0..<4 {
          var totalLoss = 0
          var currentPosition = Position(row: row, column: column)
          var stepsLoss: [StepsLoss] = []

          for step in 1...stepRange.upperBound {
            currentPosition.row += directions[direction].row
            currentPosition.column += directions[direction].column

            guard
              currentPosition.row >= 0 && currentPosition.row < rows && currentPosition.column >= 0
                && currentPosition.column < columns
            else { break }

            totalLoss += grid[currentPosition.row][currentPosition.column]

            if step >= stepRange.lowerBound {
              stepsLoss.append(StepsLoss(totalLoss: totalLoss, position: currentPosition))
            }
          }

          let lossDirection = LossDirection(
            position: .init(row: row, column: column), direction: direction)
          precomputedLoss[lossDirection] = stepsLoss
        }
      }
    }

    return precomputedLoss
  }

  func findMinHeatLoss(grid: [[Int]], precomputedHeatLoss: LossMap) -> Int {
    struct Node: Comparable {
      let totalLoss: Int
      let position: Position
      let previousDirection: Int

      static func < (lhs: Node, rhs: Node) -> Bool { lhs.totalLoss < rhs.totalLoss }
    }

    let rows = grid.count
    let columns = grid[0].count
    var priorityQueue: Heap<Node> = [
      .init(totalLoss: 0, position: .init(row: 0, column: 0), previousDirection: -1)
    ]
    var visited: Set<LossDirection> = []

    while !priorityQueue.isEmpty {
      let node = priorityQueue.removeMin()

      if node.position == Position(row: rows - 1, column: columns - 1) { return node.totalLoss }

      let visit = LossDirection(position: node.position, direction: node.previousDirection)
      guard !visited.contains(visit) else { continue }
      visited.insert(visit)

      for direction in 0..<4
      where direction != node.previousDirection && direction != (node.previousDirection + 2) % 4 {
        guard
          let stepsLoss = precomputedHeatLoss[.init(position: node.position, direction: direction)]
        else {
          continue
        }

        for step in stepsLoss {
          if !visited.contains(.init(position: step.position, direction: direction)) {
            priorityQueue.insert(
              .init(
                totalLoss: node.totalLoss + step.totalLoss, position: step.position,
                previousDirection: direction)
            )
          }
        }
      }
    }

    return Int.max
  }

  // MARK: - Data

  let grid: [[Int]]
  let directions: [Position] = [
    .init(row: 0, column: 1), .init(row: 1, column: 0), .init(row: 0, column: -1),
    .init(row: -1, column: 0),
  ]

  init(data: String) {
    grid = data.split(whereSeparator: \.isNewline).map { line in line.map { Int($0) } }
  }

  // MARK: - Models

  struct Position: Hashable {
    var row: Int
    var column: Int
  }

  struct StepsLoss {
    var totalLoss: Int
    var position: Position
  }

  struct LossDirection: Hashable {
    var position: Position
    var direction: Int
  }

  struct LossMap {
    private var map: [LossDirection: [StepsLoss]] = [:]

    subscript(lossDirection: LossDirection) -> [StepsLoss]? {
      get { map[lossDirection] }
      set { map[lossDirection] = newValue }
    }
  }
}
