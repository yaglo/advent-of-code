// MARK: Day 22: Monkey Map -

import AdventOfCode
import Algorithms
import Foundation

class Day22: AdventDay {
  // MARK: -

  func part1() -> Int {
    setUpWrappingRulesForPart1()
    return executeInstructions()
  }

  func part2() -> Int {
    setUpWrappingRulesForPart2()
    return executeInstructions()
  }

  func executeInstructions() -> Int {
    for instruction in instructions {
      switch instruction {
      case .turn(let turn):
        direction = direction.turning(turn)
      case .step:
        let next = currentTile.next(for: direction)
        if next.type == .floor {
          currentTile = next
        }
      }
    }
    return 1000 * (currentTile.coordinate.y + 1)
      + 4 * (currentTile.coordinate.x + 1)
      + direction.rawValue
  }

  func setUpWrappingRulesForPart1() {
    for row in tiles {
      let leftmostTile = row.firstNonNil { $0 }!
      let rightmostTile = row.reversed().firstNonNil { $0 }!
      leftmostTile.left = rightmostTile
      rightmostTile.right = leftmostTile
    }

    for x in 0..<width {
      let upperTile = tiles[column: x].firstNonNil { $0 }!
      let lowerTile = tiles[column: x].reversed().firstNonNil { $0 }!
      upperTile.up = lowerTile
      lowerTile.down = upperTile
    }

    for (y, row) in tiles.enumerated() {
      for (x, tile) in row.enumerated() {
        guard let tile else { continue }
        if tile.left == nil { tile.left = tiles[y][x - 1] }
        if tile.right == nil { tile.right = tiles[y][x + 1] }
        if tile.up == nil { tile.up = tiles[y - 1][x] }
        if tile.down == nil { tile.down = tiles[y + 1][x] }
      }
    }
  }

  func setUpWrappingRulesForPart2() {
    // 
    for row in tiles {
      let leftmostTile = row.firstNonNil { $0 }!
      let rightmostTile = row.reversed().firstNonNil { $0 }!
      leftmostTile.left = rightmostTile
      rightmostTile.right = leftmostTile
    }

    for x in 0..<width {
      let upperTile = tiles[column: x].firstNonNil { $0 }!
      let lowerTile = tiles[column: x].reversed().firstNonNil { $0 }!
      upperTile.up = lowerTile
      lowerTile.down = upperTile
    }

    for (y, row) in tiles.enumerated() {
      for (x, tile) in row.enumerated() {
        guard let tile else { continue }
        if tile.left == nil { tile.left = tiles[y][x - 1] }
        if tile.right == nil { tile.right = tiles[y][x + 1] }
        if tile.up == nil { tile.up = tiles[y - 1][x] }
        if tile.down == nil { tile.down = tiles[y + 1][x] }
      }
    }
  }


  // MARK: - Data

  var currentTile: Tile
  var direction = Direction.right

  var tiles: [[Tile?]]
  let startTile: Tile
  let instructions: [Instruction]
  let width: Int

  required init(data: String) {
    let (map, instructionString) = data.split(separator: "\n\n").splat()

    width = map.lines().map(\.count).max()!

    tiles = map.lines().enumerated().map { y, line in
      return line.enumerated().map { x, character -> Tile? in
        return switch character {
        case ".": Tile(coordinate: .init(x: x, y: y), type: .floor)
        case "#": Tile(coordinate: .init(x: x, y: y), type: .wall)
        default: nil
        }
      }
    }

    for (y, row) in tiles.enumerated() {
      for _ in row.count..<width {
        tiles[y].append(nil)
      }
    }

    startTile = tiles.first!.firstNonNil { $0 }!
    currentTile = startTile

    self.instructions =
      instructionString
      .trimmingCharacters(in: .newlines)
      .chunked { $0.isNumber && $1.isNumber || $0.isLetter && $1.isLetter }
      .flatMap { instruction -> [Instruction] in
        switch instruction {
        case "L": [.turn(.left)]
        case "R": [.turn(.right)]
        default: (0..<Int(String(instruction))!).map { _ in .step }
        }
      }

    print(instructions)
  }

  // MARK: - Models

  struct Coordinate {
    let x, y: Int
  }

  class Tile {
    enum `Type` {
      case floor, wall
    }
    let coordinate: Coordinate
    let type: `Type`

    weak var right: Tile?
    weak var down: Tile?
    weak var left: Tile?
    weak var up: Tile?

    init(
      coordinate: Coordinate, type: Type, right: Tile? = nil, down: Tile? = nil, left: Tile? = nil,
      up: Tile? = nil
    ) {
      self.coordinate = coordinate
      self.type = type
      self.right = right
      self.down = down
      self.left = left
      self.up = up
    }

    func next(for direction: Direction) -> Tile {
      switch direction {
      case .right:
        right!
      case .down:
        down!
      case .left:
        left!
      case .up:
        up!
      }
    }
  }

  enum Instruction {
    case turn(Turn)
    case step
  }

  enum Turn {
    case left, right
  }

  enum Direction: Int {
    case right, down, left, up

    func turning(_ turn: Turn) -> Direction {
      switch self {
      case .right: turn == .left ? .up : .down
      case .down: turn == .left ? .right : .left
      case .left: turn == .left ? .down : .up
      case .up: turn == .left ? .left : .right
      }
    }
  }
}

extension Array where Element: Collection {
  subscript(column column: Element.Index) -> [Element.Iterator.Element] {
    return map { $0[column] }
  }
}
