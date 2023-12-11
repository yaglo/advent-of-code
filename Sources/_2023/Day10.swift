// MARK: Day 10: Pipe Maze -

import AdventOfCode
import Algorithms

struct Day10: AdventDay {
  // MARK: -

  func part1() -> Int {
    grid.walkLoop(from: grid.startNode) / 2
  }

  func part2() -> Int {
    grid.walkLoop(from: grid.startNode)
    grid.markOutsideTiles()
    return grid.countInsideTiles()
  }

  // MARK: - Data

  let grid: Grid

  init(data: String) {
    grid = Grid(from: data)
  }

  // MARK: - Models

  struct Coordinate: Hashable {
    let x, y: Int
  }

  class Node: Hashable {
    enum Shape: Character {
      case start = "S"
      case empty = "."
      case v = "|"
      case h = "-"
      case l = "L"
      case j = "J"
      case s = "7"
      case f = "F"

      var isEmpty: Bool {
        self == .empty
      }

      func exposedEnds(from: Coordinate) -> Set<Coordinate> {
        switch self {
        case .start:
          [
            Coordinate(x: from.x, y: from.y - 1),
            Coordinate(x: from.x, y: from.y + 1),
            Coordinate(x: from.x - 1, y: from.y),
            Coordinate(x: from.x + 1, y: from.y),
          ]
        case .v:
          [Coordinate(x: from.x, y: from.y - 1), Coordinate(x: from.x, y: from.y + 1)]
        case .h:
          [Coordinate(x: from.x - 1, y: from.y), Coordinate(x: from.x + 1, y: from.y)]
        case .l:
          [Coordinate(x: from.x, y: from.y - 1), Coordinate(x: from.x + 1, y: from.y)]
        case .j:
          [Coordinate(x: from.x, y: from.y - 1), Coordinate(x: from.x - 1, y: from.y)]
        case .s:
          [Coordinate(x: from.x - 1, y: from.y), Coordinate(x: from.x, y: from.y + 1)]
        case .f:
          [Coordinate(x: from.x + 1, y: from.y), Coordinate(x: from.x, y: from.y + 1)]
        case .empty:
          []
        }
      }
    }

    var shape: Shape
    var neighbors: Set<Node> = []
    var isOutside = false
    var isPartOfLoop = false

    init(shape: Shape) {
      self.shape = shape
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
      return lhs === rhs
    }

    func hash(into hasher: inout Hasher) {
      hasher.combine(ObjectIdentifier(self))
    }
  }

  class Grid {
    var nodes: [[Node]]
    var startNode: Node

    init(from data: String) {
      nodes = data.mapLines { $0.map { Node(shape: Node.Shape(rawValue: $0)!) } }
      startNode = nodes.flatMap { $0 }.first(where: { $0.shape == .start })!

      connectNodes()
      cleanUpDanglingNodes()
    }

    func countInsideTiles() -> Int {
      nodes
        .joined()
        .filter { $0.shape.isEmpty && !$0.isOutside }
        .count
    }

    @discardableResult
    func walkLoop(from startNode: Node) -> Int {
      var current = startNode
      var previous: Node? = nil
      var steps = 1

      while let next = current.neighbors.first(where: { $0 !== previous && !$0.isPartOfLoop }) {
        steps += 1
        previous = current
        current = next
        current.isPartOfLoop = true
      }

      return steps
    }

    func boundsCheckedNode(at c: Coordinate) -> Node? {
      guard c.y >= 0, c.y < nodes.count, c.x >= 0, c.x < nodes[c.y].count else { return nil }
      return nodes[c.y][c.x]
    }

    func connectNodes() {
      for (y, row) in nodes.enumerated() {
        for (x, node) in row.enumerated() {
          guard !node.shape.isEmpty else { continue }
          let myCoordinate = Coordinate(x: x, y: y)
          let myExposedEnds = node.shape.exposedEnds(from: myCoordinate)
          let joinableNeighbors = Set(
            myExposedEnds.compactMap { neighborCoordinate -> Node? in
              guard let node = boundsCheckedNode(at: neighborCoordinate),
                node.shape.exposedEnds(from: neighborCoordinate).contains(myCoordinate)
              else {
                return nil
              }
              return node
            })
          for neighbor in joinableNeighbors {
            node.neighbors.insert(neighbor)
          }
        }
      }
    }

    func cleanUpDanglingNodes() {
      var foundSingleNeighborNodes = true

      while foundSingleNeighborNodes {
        foundSingleNeighborNodes = false
        for (y, row) in nodes.enumerated() {
          for (x, node) in row.enumerated() {
            if !node.shape.isEmpty, node.neighbors.count != 2 {
              foundSingleNeighborNodes = true
              for neighbor in node.neighbors {
                neighbor.neighbors.remove(node)
              }
              nodes[y][x] = Node(shape: .empty)
            }
          }
        }
      }
    }

    enum Color: Int8 {
      case notFilled = 0
      case loop = 1
      case outside = 2
      case other = -1
    }

    func markOutsideTiles() {
      let rows = nodes.count
      let cols = nodes[0].count

      var bitmap: [[Color]] = Array(
        repeating: Array(repeating: Color.notFilled, count: cols * 3), count: rows * 3)

      for y in 0..<rows {
        for x in 0..<cols {
          draw(nodes[y][x], at: Coordinate(x: x, y: y), in: &bitmap)
        }
      }

      fill(&bitmap)

      // Mark all outside nodes from the bitmap values
      for y in stride(from: 0, to: bitmap.count, by: 3) {
        for x in stride(from: 0, to: bitmap[0].count, by: 3) {
          if bitmap[y][x] == .outside {
            nodes[y / 3][x / 3].isOutside = true
          }
        }
      }
    }

    func draw(_ node: Node, at coord: Coordinate, in bitmap: inout [[Color]]) {
      guard node.shape != .empty else { return }

      let bx = coord.x * 3
      let by = coord.y * 3

      let pattern = pattern(for: node.shape, withColor: node.isPartOfLoop ? .loop : .other)
      for (i, rowPattern) in pattern.enumerated() {
        bitmap[by + i].replaceSubrange(bx..<bx + 3, with: rowPattern)
      }
    }

    func pattern(for shape: Node.Shape, withColor c: Color) -> [[Color]] {
      let z = Color.notFilled
      return switch shape {
      case .v: [[z, c, z], [z, c, z], [z, c, z]]
      case .h: [[z, z, z], [c, c, c], [z, z, z]]
      case .l: [[z, c, z], [z, c, c], [z, z, z]]
      case .j: [[z, c, z], [c, c, z], [z, z, z]]
      case .s: [[z, z, z], [c, c, z], [z, c, z]]
      case .f: [[z, z, z], [z, c, c], [z, c, z]]
      case .start: [[.loop, .loop, .loop], [.loop, .loop, .loop], [.loop, .loop, .loop]]
      default:
        fatalError()
      }
    }

    func fill(_ bitmap: inout [[Color]]) {
      var paintingStack: [Coordinate] = []

      for y in 0..<bitmap.count {
        if bitmap[y][0] == .notFilled {
          paintingStack.append(.init(x: 0, y: y))
        }
        if bitmap[y][bitmap[0].count - 1] == .notFilled {
          paintingStack.append(.init(x: bitmap[0].count - 1, y: y))
        }
      }

      for x in 0..<bitmap[0].count {
        if bitmap[0][x] == .notFilled {
          paintingStack.append(.init(x: x, y: 0))
        }
        if bitmap[bitmap.count - 1][x] == .notFilled {
          paintingStack.append(.init(x: x, y: bitmap.count - 1))
        }
      }

      // Mark all outside pixels
      while let coord = paintingStack.popLast() {
        if bitmap[coord.y][coord.x] != .outside {
          bitmap[coord.y][coord.x] = .outside

          for y in max(0, coord.y - 1)...min(bitmap.count - 1, coord.y + 1) {
            for x in max(0, coord.x - 1)...min(bitmap[0].count - 1, coord.x + 1) {
              if ![.outside, .loop].contains(bitmap[y][x]) {
                paintingStack.append(.init(x: x, y: y))
              }
            }
          }
        }
      }
    }
  }
}

// MARK: - Debugging

extension Day10.Node.Shape: CustomStringConvertible {
  var description: String {
    switch self {
    case .empty:
      "█"
    case .v:
      "│"
    case .h:
      "─"
    case .l:
      "└"
    case .j:
      "┘"
    case .s:
      "┐"
    case .f:
      "┌"
    case .start:
      "🯆"
    }
  }
}

extension Day10.Grid {
  func dump() {
    for (_, line) in nodes.enumerated() {
      for (_, node) in line.enumerated() {
        print(
          "\(node.shape, color: node.isPartOfLoop ? .red : node.isOutside ? .green : .black)",
          terminator: "")
      }
      print()
    }
  }
}
