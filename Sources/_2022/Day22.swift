// MARK: Day 22: Monkey Map -

import AdventOfCode
import Algorithms
import Foundation

var history: [Float] = []

class Day22: AdventDay {
  // MARK: -

  func part1() -> Int {
    currentTile = startTile
    setUpWrappingRulesForPart1()
    return executeInstructions()
  }

  func part2() -> Int {
    currentTile = startTile
    setUpWrappingRulesForPart2()

    let startingSide = sides[currentTile.sideID]
    direction = startingSide.transformedDirection()
    return executeInstructions()
  }

  func executeInstruction(_ instruction: Instruction) {
    switch instruction {
    case .turn(let turn): direction = direction.turning(turn)
    case .step:
      let next = currentTile.next(for: direction)
      let newDirection = currentTile.directionChange[direction]
      if next.type == .floor {
        history.append(currentTile.coordinate)
        currentTile = next

        if let newDirection { direction = newDirection }
      }
    }
  }

  func executeInstructions() -> Int {
    for instruction in instructions { executeInstruction(instruction) }
    let direction =
      currentTile.sideID == -1
      ? direction.rawValue
      : (4 - sides[currentTile.sideID].direction.rawValue + direction.rawValue) % 4
    return Int(currentTile.coordinate) + direction
  }

  func setUpWrappingRulesForPart1() {
    for row in tiles {
      let leftmostTile = row.firstNonNil { $0 }!
      let rightmostTile = row.reversed().firstNonNil { $0 }!
      leftmostTile.neighbors[.left] = rightmostTile
      rightmostTile.neighbors[.right] = leftmostTile
    }

    for x in 0..<width {
      let upperTile = tiles[column: x].firstNonNil { $0 }!
      let lowerTile = tiles[column: x].reversed().firstNonNil { $0 }!
      upperTile.neighbors[.up] = lowerTile
      lowerTile.neighbors[.down] = upperTile
    }

    for (y, row) in tiles.enumerated() {
      for (x, tile) in row.enumerated() {
        guard let tile else { continue }
        if tile.neighbors[.left] == nil { tile.neighbors[.left] = tiles[y][safe: x - 1] }
        if tile.neighbors[.right] == nil { tile.neighbors[.right] = tiles[y][safe: x + 1] }
        if tile.neighbors[.up] == nil { tile.neighbors[.up] = tiles[safe: y - 1]?[x] }
        if tile.neighbors[.down] == nil { tile.neighbors[.down] = tiles[safe: y + 1]?[x] }
      }
    }
  }

  func setUpWrappingRulesForPart2() { createTransformedTileMap() }

  // MARK: - Data

  var currentTile: Tile
  var direction = Direction.right

  var tiles: [[Tile?]]
  var tileMap: [Int: Tile?] = [:]
  let startTile: Tile
  let instructions: [Instruction]
  let width: Int
  let height: Int

  required init(data: String) {
    let (map, instructionString) = data.split(separator: "\n\n")
      .map { $0.trimmingCharacters(in: .newlines) }.splat()

    height = map.lines().count
    width = map.lines().map(\.count).max()!

    // Real and test data
    sideSize = width > 20 ? 50 : 4

    tiles = Array(repeating: Array(repeating: nil, count: width), count: height)

    for (y, line) in map.lines().enumerated() {
      for (x, character) in line.enumerated() {
        tiles[y][x] =
          switch character {
          case ".": Tile(coordinate: float(from: (x, y)), type: .floor, sideID: -1)
          case "#": Tile(coordinate: float(from: (x, y)), type: .wall, sideID: -1)
          default: nil
          }
      }
    }

    for tile in tiles.joined().compactMap({ $0 }) { tileMap[Int(tile.coordinate)] = tile }

    startTile = tiles.first!.firstNonNil { $0 }!
    currentTile = startTile

    self.instructions = instructionString.trimmingCharacters(in: .newlines)
      .chunked { $0.isNumber && $1.isNumber || $0.isLetter && $1.isLetter }
      .flatMap { instruction -> [Instruction] in
        switch instruction {
        case "L": [.turn(.left)]
        case "R": [.turn(.right)]
        default: (0..<Int(String(instruction))!).map { _ in .step }
        }
      }
  }

  // MARK: - Models

  class Side {
    let id: Int
    var coordinates: [[Float]]
    var direction: Direction
    var flipped = false

    enum Transformation {
      case flip
      case rotate
    }
    var transformations: [Transformation] = []

    init(id: Int, coordinates: [[Float]]) {
      self.id = id
      self.coordinates = coordinates
      self.direction = .right
    }

    func rotate() {
      guard id > 0 else { return }
      rotateMatrix(&coordinates)
      direction = direction.rotatedRight()
      transformations.append(.rotate)
    }

    func flip() {
      guard id > 0 else { return }
      flipped.toggle()
      flipMatrix(&coordinates)
      direction = direction.flipped()
      transformations.append(.flip)
    }

    func transformedDirection(reverse: Bool = true) -> Direction {
      let t = reverse ? transformations.reversed() : transformations
      return t.reduce(direction) { partialResult, t in
        switch t {
        case .flip: partialResult.flipped()
        case .rotate: reverse ? partialResult.rotatedLeft() : partialResult.rotatedRight()
        }
      }
    }
  }

  enum Instruction {
    case turn(Turn)
    case step
  }

  enum Turn { case left, right }

  enum Direction: Int, Hashable {
    init?(rawValue: Int) {
      self =
        switch rawValue % 4 {
        case 0: .right
        case 1: .down
        case 2: .left
        case 3: .up
        default: fatalError()
        }
    }

    func rotatedRight(_ times: Int = 1) -> Direction { Direction(rawValue: (rawValue + 1) % 4)! }

    func rotatedLeft(_ times: Int = 1) -> Direction { Direction(rawValue: abs(rawValue - 1) % 4)! }

    func flipped() -> Direction {
      if [.left, .right].contains(self) { Direction(rawValue: (rawValue + 2) % 4)! } else { self }
    }

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

  class Tile {
    enum `Type` { case floor, wall }
    let coordinate: Float
    let type: `Type`
    var sideID: Int

    var neighbors: [Direction: Tile?] = [:]
    var directionChange: [Direction: Direction] = [:]

    init(coordinate: Float, type: Type, sideID: Int) {
      self.coordinate = coordinate
      self.type = type
      self.sideID = sideID
    }

    func next(for direction: Direction) -> Tile { neighbors[direction]!! }
  }

  let sideSize: Int
  var sides: [Side] = []
  var grid: [[Int]] = []

  private let crossShape = [[0, 1, 0], [1, 1, 1], [0, 1, 0], [0, 1, 0]]

  private let shaper = [
    [[[1, 1, 1], [0, 1, 0], [0, 1, 0], [0, 1, 0]], [[-1, 0, 0, 0, 1]]],
    [[[0, 1, 1], [1, 1, 0], [0, 1, 0], [0, 1, 0]], [[1, 2, 0, 0, 1]]],
    [[[0, 1, 1], [0, 1, 0], [1, 1, 0], [0, 1, 0]], [[1, 0, 2, 0, -1]]],
    [[[0, 1, 1], [0, 1, 0], [0, 1, 0], [1, 1, 0]], [[1, 0, 3, 0, -1]]],
    [[[0, 1, 0], [1, 1, 0], [0, 1, 1], [0, 1, 0]], [[-1, 2, 2, 0, -1]]],
    [[[1, 0, 0], [1, 1, 0], [0, 1, 1], [0, 1, 0]], [[1, 0, 0, 1, 0]]],
    [[[1, 0, 0], [1, 1, 0], [0, 1, 0], [0, 1, 1]], [[-1, 2, 3, 0, -1]]],
    [[[1, 0, 0], [1, 1, 1], [0, 1, 0], [0, 1, 0]], [[1, 0, 0, 1, 0]]],
    [[[1, 0, 0], [1, 1, 0], [0, 1, 1], [0, 0, 1]], [[1, 3, 3, -1, 0]]],
    [[[1, 1, 1, 0, 0], [0, 0, 1, 1, 1]], [[2, 0, 0, 1, -1], [2, 3, 2, -1, 1]]],
  ]

  private var shape: [[Int]] { grid.map { line in line.map { $0 != 0 ? 1 : 0 } } }

  func createNet() {
    var grid: [[Int]] = []
    var index = 1

    for y in stride(from: 0, to: height, by: sideSize) {
      var row: [Int] = []
      for x in stride(from: 0, to: width, by: sideSize) {
        if tiles[y][x] == nil {
          row.append(0)
        } else {
          row.append(index)
          index += 1
        }
      }
      grid.append(row)
    }

    self.grid = grid

    sides.append(Side(id: 0, coordinates: []))

    var sideID = 1
    for (y, row) in grid.enumerated() {
      for (x, value) in row.enumerated() {
        guard value > 0 else { continue }
        let side = Side(
          id: sideID,
          coordinates: (y * sideSize..<(y + 1) * sideSize)
            .map { ty in (x * sideSize..<(x + 1) * sideSize).map { tx in float(from: (tx, ty)) } }
        )
        sideID += 1
        sides.append(side)
      }
    }

    transformIntoCross()

    func transformIntoCross() {
      let transformations = [rotate, rotate, rotate, rotate, flip, rotate, rotate, rotate, rotate]

      guard shape != crossShape else { return }

      for t in transformations {
        guard shape != crossShape, !shaper.contains(where: { $0[0] == shape }) else { break }
        t()
      }

      assert(shaper.contains(where: { $0[0] == shape }))

      while let shape = shaper.first(where: { $0[0] == shape }) {
        for t in shape[1] { move(x: t[1], y: t[2], tx: t[3], ty: t[4], rotation: t[0]) }
      }

      if flipped { flip() }

      assert(shape == crossShape)
    }
  }

  private func rotate() {
    var input: [[Float]] = grid.map { $0.map { Float($0) } }
    rotateMatrix(&input)
    grid = input.map { $0.map { Int($0) } }
    for side in sides { side.rotate() }
  }

  private var flipped = false

  private func flip() {
    flipped.toggle()
    grid = grid.map { $0.reversed() }
    for side in sides { side.flip() }
  }

  private func move(x: Int, y: Int, tx: Int, ty: Int, rotation: Int) {
    let item = grid[y][x]
    sides.first(where: { $0.id == item })?.rotate()
    grid[y][x] = 0
    insert(item: item, x: x + tx, y: y + ty)
  }

  private func insert(item: Int, x: Int, y: Int) {
    if y < 0 { grid.insert(Array([0].cycled(times: grid[0].count)), at: 0) }
    if y >= grid.count { grid.append(Array([0].cycled(times: grid[0].count))) }
    if x < 0 { grid = grid.map { [0] + $0 } }
    if x >= grid[0].count { grid = grid.map { $0 + [0] } }
    grid[y][x] = item

    // Remove empty rows
    grid = grid.filter { $0.contains { $0 != 0 } }

    // Remove empty columns
    let emptyColumns = Set(grid[0].indices.filter { grid[column: $0].allSatisfy { $0 == 0 } })
    grid = grid.map { $0.enumerated().compactMap { emptyColumns.contains($0) ? nil : $1 } }
  }

  func createTransformedTileMap() {
    createNet()

    var transformedTiles: [[Tile?]] = Array(
      repeating: Array(repeating: nil, count: 3 * sideSize),
      count: 4 * sideSize
    )

    for (y, row) in grid.enumerated() {
      for (x, item) in row.enumerated() {
        let side = sides[item]
        for (sy, srow) in side.coordinates.enumerated() {
          for (sx, coord) in srow.enumerated() {
            let ty = y * sideSize + sy
            let tx = x * sideSize + sx
            transformedTiles[ty][tx] = tileMap[Int(coord)]!
            transformedTiles[ty][tx]?.sideID = item
          }
        }
      }
    }

    for (y, row) in transformedTiles.enumerated() {
      for (x, tile) in row.enumerated() {
        guard let tile else { continue }
        if tile.neighbors[.left] == nil { tile.neighbors[.left] = transformedTiles[y][safe: x - 1] }
        if tile.neighbors[.right] == nil {
          tile.neighbors[.right] = transformedTiles[y][safe: x + 1]
        }
        if tile.neighbors[.up] == nil { tile.neighbors[.up] = transformedTiles[safe: y - 1]?[x] }
        if tile.neighbors[.down] == nil {
          tile.neighbors[.down] = transformedTiles[safe: y + 1]?[x]
        }
      }
    }

    typealias CoordinateStrategy = (
      xBlock: Int, xOffset: Int, xIncrement: Int, yBlock: Int, yOffset: Int, yIncrement: Int
    )

    // x & y triplets: (size * 0 + 1) + i * 2
    let tinc = (0, 0, 1, 0, 0, 0)
    let tdec = (1, -1, -1, 0, 0, 0)

    let binc = (0, 0, 1, 1, -1, 0)
    let bdec = (1, -1, -1, 1, -1, 0)

    let linc = (0, 0, 0, 0, 0, 1)
    let ldec = (0, 0, 0, 1, -1, -1)

    let rinc = (1, -1, 0, 0, 0, 1)
    let rdec = (1, -1, 0, 1, -1, -1)

    typealias NetCoordinate = (x: Int, y: Int)
    typealias SideMapping = (
      source: NetCoordinate, destination: NetCoordinate, direction: Direction,
      directionChange: Direction, scoord: CoordinateStrategy, dcoord: CoordinateStrategy
    )

    let sideMap: [SideMapping] = [
      ((1, 0), (1, 3), .up, .up, tinc, binc),  // 1U > 6D
      ((1, 0), (0, 1), .left, .down, linc, tinc),  // 1L > 2U
      ((0, 1), (1, 0), .up, .right, tinc, linc),  // 2U > 1L
      ((0, 1), (1, 3), .left, .right, linc, ldec),  // 2L > 6L
      ((0, 1), (1, 2), .down, .right, binc, ldec),  // 2D > 5L
      ((1, 2), (0, 1), .left, .up, ldec, binc),  // 5L > 2D
      ((1, 3), (0, 1), .left, .left, ldec, linc),  // 6L > 2L
      ((1, 3), (1, 0), .down, .down, binc, tinc),  // 6D > 1U
      ((1, 3), (2, 1), .right, .left, rdec, rinc),  // 6R > 4R
      ((1, 2), (2, 1), .right, .up, rdec, bdec),  // 5R > 4D
      ((2, 1), (1, 2), .down, .left, bdec, rdec),  // 4D > 5R
      ((2, 1), (1, 3), .right, .left, rdec, rinc),  // 4R > 6R
      ((2, 1), (1, 0), .up, .left, tdec, rinc),  // 4U > 1R
      ((1, 0), (2, 1), .right, .down, rinc, tdec),  // 1R > 4U
    ]

    let sz = sideSize
    for m in sideMap {
      let s = (
        x: (m.source.x + m.scoord.xBlock) * sz + m.scoord.xOffset,
        y: (m.source.y + m.scoord.yBlock) * sz + m.scoord.yOffset
      )
      let d = (
        x: (m.destination.x + m.dcoord.xBlock) * sz + m.dcoord.xOffset,
        y: (m.destination.y + m.dcoord.yBlock) * sz + m.dcoord.yOffset
      )
      for i in 0..<sz {
        let src = (x: s.x + i * m.scoord.xIncrement, y: s.y + i * m.scoord.yIncrement)
        let dst = (x: d.x + i * m.dcoord.xIncrement, y: d.y + i * m.dcoord.yIncrement)
        transformedTiles[src.y][src.x]!.neighbors[m.direction] = transformedTiles[dst.y][dst.x]!
        transformedTiles[src.y][src.x]!.directionChange[m.direction] = m.directionChange
      }
    }
    self.tiles = transformedTiles
  }
}

private func coordinate(from: Float) -> (Int, Int) {
  let x = (Int(from) % 1000 / 4 - 1)
  let y = (Int(from) - x) / 1000 - 1
  return (x, y)
}

private func float(from: (x: Int, y: Int)) -> Float {
  Float(from.y + 1) * 1000 + Float(from.x + 1) * 4
}
