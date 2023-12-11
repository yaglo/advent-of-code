// MARK: Day 22: Monkey Map -

import AdventOfCode
import Algorithms
import Foundation
import CoreGraphics

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
    let mapper = CubeMapper(tiles: tiles)
    mapper.side = 50
    let (net, seams) = mapper.createNet()

    print("START >", startTile.coordinate)
    executeInstructions()

    print("now we are at:")
    print(currentTile.coordinate)
    print(direction)
    print(currentTile.next(for: .right).coordinate)

    return executeInstructions()
  }

  func executeInstructions() -> Int {
    for instruction in instructions {
      switch instruction {
      case .turn(let turn):
        direction = direction.turning(turn)
      case .step:
        let next = currentTile.next(for: direction)
        let force = currentTile.force[direction]
        if next.type == .floor {
          currentTile = next
        }

        // Apply the turning force
        if let force {
          for turn in force {
            direction = direction.turning(turn)
          }
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
    // Neighboring L
    // Corner - 100,50
    //
    // Seam (x: 100, y: 50..<100) -> (x: 100..<150, y: 50)
    // Force: L
    // 100,50 -> 100,50
    // 100,100 -> 150,50

    // Other way:
    // Seam (x: 100..<150, y: 50) -> (x: 100, y: 50..<100)
    // Force: R
    // 150,50 -> 100,50
    // 100,50 -> 100,50

    // Seam (x: 100, y: 100..<150) -> (x: 150, y: 50..<0)
    // Force: LL
    // 100,100 -> 150,50
    // 100,150 -> 150,0

    // Other way:
    // Force: LL
    // 150,50 -> 100,100
    // 150,0 -> 100,150


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
//    let data = """
//          ...#
//          .#..
//          #...
//          ....
//  ...#.......#
//  ........#...
//  ..#....#....
//  ..........#.
//          ...#....
//          .....#..
//          .#......
//          ......#.
//
//  2R5L2
//  """
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
    var force: [Direction: [Turn]] = [:]

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

  class CubeMapper {
    struct Transformations {
      static let flipVerticallyRotate90 = CGAffineTransformRotate(CGAffineTransformMakeScale(1, -1), .pi / 2)
    }

    let mappings: [(Int, Int, Direction, Direction, CGAffineTransform, [Day22.Turn])] = [
      // horizontal distance - flip flop positive/negative
      // vertical distance - flip flop positive/negative
      // parallel or orthogonal - constant
      // x to y? or x to x. direct or inverse?
      // y to x? or y to y. direct or inverse?
      // direction
      // direction shift
      //      (4, 0, true, 1, 1, []), // 1
      (1, 1, .right, .up, Transformations.flipVerticallyRotate90, [.right]), // 1
    ]

    var tiles: [[Tile?]]
    var side = 1

    init(tiles: [[Tile?]]) {
      self.tiles = tiles
    }

    class Seam {
      var color: Int = 41
      let x: Range<Int>
      let y: Range<Int>

      init(x: Range<Int>, y: Range<Int>) {
        self.x = x
        self.y = y
      }
    }

    func createNet() -> (net: [[Int]], seams: [Seam]) {
      let height = tiles.count
      let width = tiles.first!.count

      var net: [[Int]] = []
      for y in stride(from: 0, to: height, by: side) {
        var row: [Int] = []
        for x in stride(from: 0, to: width, by: side) {
          row.append(tiles[y][x] == nil ? 0 : 1)
        }
        net.append(row)
      }

      let netHeight = height / side
      let netWidth = width / side

      var seams: [Seam] = []

      func netToSeam(x: Int, y: Int, direction: Direction) -> (x: Range<Int>, y: Range<Int>) {
        switch direction {
        case .right:
          (x: (x + 1) * side - 1..<(x + 1) * side, y: y * side..<(y + 1) * side)
        case .down:
          (x: x * side..<(x + 1) * side, y: (y + 1) * side - 1..<(y + 1) * side)
        case .left:
          (x: x * side..<x * side + 1, y: y * side..<(y + 1) * side)
        case .up:
          (x: x * side..<(x + 1) * side, y: y * side..<y * side + 1)
        }
      }

      for (y, row) in net.enumerated() {
        for (x, value) in row.enumerated() {
          guard value == 1 else { continue }
          var directions: [Direction] = []
          if x == 0 || row[x - 1] == 0 {
            directions.append(.left)
          }
          if y == 0 || net[y - 1][x] == 0 {
            directions.append(.up)
          }
          if x == netWidth - 1 || row[x + 1] == 0 {
            directions.append(.right)
          }
          if y == netHeight - 1 || net[y + 1][x] == 0 {
            directions.append(.down)
          }
          for direction in directions {
            let seam = netToSeam(x: x, y: y, direction: direction)
            seams.append(Seam(x: seam.x, y: seam.y))
          }
        }
      }

      func dumpSeams() {
        for (y, row) in tiles.enumerated() {
          for (x, value) in row.enumerated() {
            let seam = seams.first { $0.x.contains(x) && $0.y.contains(y) }
            let inSeam = seam != nil
            if value == nil {
              print(" ", terminator: "")
              //          } else if inSeam {
              //            print("\("█", color: .red)", terminator: "")
            } else if value?.type == .floor {
              if inSeam {
                print("\u{001B}[0;\(seam!.color)m.\u{001B}[0;0m", terminator: "")
              } else {
                print("\u{001B}[0;94m.\u{001B}[0;0m", terminator: "")
              }
            } else if value?.type == .wall {
              if inSeam {
                print("\u{001B}[0;\(seam!.color)m#\u{001B}[0;0m", terminator: "")
              } else {
                print("\u{001B}[0;94m#\u{001B}[0;0m", terminator: "")
              }
            }
          }
          print()
        }
      }

      dumpSeams()

      func findSeam(x: Int, y: Int, direction: Direction) -> Seam? {
        let (xrange, yrange) = netToSeam(x: x, y: y, direction: direction)
        let x = xrange.lowerBound + xrange.count / 2
        let y = yrange.lowerBound + yrange.count / 2
        return seams.first { $0.x.contains(x) && $0.y.contains(y) }
      }

      for mapping in mappings {
        for (y, row) in net.enumerated() {
          for (x, value) in row.enumerated() {
            guard value != 0 else { continue }
            
            let otherx = x + mapping.0
            let othery = y + mapping.1
            
            guard otherx < netWidth else { continue }
            guard othery < netHeight else { continue }
            guard net[othery][otherx] == 1 else { continue }

            guard let mySeam = findSeam(x: x, y: y, direction: mapping.2),
                  let otherSeam = findSeam(x: x + mapping.0, y: y + mapping.1, direction: mapping.3) else {
              continue
            }

            print("for \(x), \(y) found")
            dump(mySeam)
            dump(otherSeam)

            mySeam.color = 103
            otherSeam.color = 103

            let transformation = mapping.4


            for (_, y) in mySeam.y.enumerated() {
              for (_, x) in mySeam.x.enumerated() {
                let translation = CGAffineTransform(translationX: CGFloat(mySeam.y.lowerBound + side - 1), y: CGFloat(mySeam.x.lowerBound))
                let transform = CGAffineTransformConcat(transformation, translation)
                let transformed = CGPointApplyAffineTransform(CGPoint(x: x, y: y), transform)
                let otherx = otherSeam.x.lowerBound + Int(transformed.x)
                let othery = otherSeam.y.lowerBound + Int(transformed.y)

                print(y, x,tiles[y][x]?.coordinate, tiles[y][x]?.right?.coordinate, tiles[othery][otherx]?.coordinate)
                tiles[y][x]?.right = tiles[othery][otherx]
                tiles[y][x]?.force[.right] = mapping.5

                print(y, x, tiles[y][x]?.coordinate, tiles[y][x]?.right?.coordinate, tiles[othery][otherx]?.coordinate)
              }
            }

//            for myy in mySeam.y {
//              for myx in mySeam.x {
//                for othery in otherSeam.y {
//                  for otherx in otherSeam.x {
//
//                  }
//                }
//              }
//            }
          }
        }
      }

      dumpSeams()

      return (net, seams)
    }
  }
}

extension Array where Element: Collection {
  subscript(column column: Element.Index) -> [Element.Iterator.Element] {
    return map { $0[column] }
  }
}

//    var nets: [[[Int]],  = [
//      [0, 1, 1],
//      [0, 1, 0],
//      [0, 1, 0],
//      [1, 0, 0]
//    ]


let mappings: [(Int, Int, Bool, Int, Int, [Day22.Turn])] = [
  // vertical distance - flip flop positive/negative
  // horizontal distance - flip flop positive/negative
  // parallel or orthogonal - constant
  // x coordinate multiplier
  // y coordinate multiplier
  // direction shift
  (4, 0, true, 1, 1, []), // 1
  (1, 1, false, 1, 0, []), // 1
]


// 1. Map fours
// *XXXX* or *
//           X
//           X
//           X
//           X
//           *

// 2. Map corners
// XX
// X*

// 3.
// .X*
// X*


// 3.
// *
// X..
// ...
// ...
// ..X
//   *

// 4.
// .X*
// ..
// X*

// 5.
// *
// X.
// ..
// ..
// .X*
//


// 6.
// .X*
// .X.
// .X.
// *X.





// 0XX
// 0X0
// XX0


// Every net has 14 free sides that need to be connected
// Patterns

// Corner

//     XXXX
//     XXXX
//     XXXX
//     1234
// XXX1
// XXX2
// XXX3
// XXX4

// 2 up/down, 1 side
//     XXX4
//     XXX3
//     XXX2
//     XXX1
// XXX1
// XXX2
// XXX3
// XXX4

// 4 in a row - same:
//     1234
//     XXXX
//     ....
//     ....
//     XXXX
//     1234

// *
// XX
//  X
//  X
// *X

// Left becomes down
// XXXX1234
// XXXXXXXX
// XXXXXXXX
// XXXXXXXX
// XXXX
// XXXX
// XXXX
// XXXX
// XXXX
// XXXX
// XXXX
// XXXX
// 1XXX
// 2XXX
// 3XXX
// 4XXX


// Any parallel with distance 4 -> same, either in one line or with 1 column inbetween
//   *
// .XX
// .X.
// XX.
// X
// *

//
//
//extension Day22.Node.Shape: CustomStringConvertible {
//  var description: String {
//    switch self {
//    case .empty:
//      "█"
//    case .v:
//      "│"
//    case .h:
//      "─"
//    case .l:
//      "└"
//    case .j:
//      "┘"
//    case .s:
//      "┐"
//    case .f:
//      "┌"
//    case .start:
//      "🯆"
//    }
//  }
//}
//
//extension Day22 {
//  func dump() {
//    for (_, line) in nodes.enumerated() {
//      for (_, node) in line.enumerated() {
//        print(
//          "\(node.shape, color: node.isPartOfLoop ? .red : node.isOutside ? .green : .black)",
//          terminator: "")
//      }
//      print()
//    }
//  }
//}



// Flip and rotate





//let side = 4
//
//let originX: CGFloat = 11
//let originY: CGFloat = 4
//
//var storedTransform = CGAffineTransformMakeScale(1, -1)
//storedTransform = CGAffineTransformRotate(storedTransform, .pi / 2)
//
//String(data: try JSONEncoder().encode(storedTransform), encoding: .utf8)
//
//var translation = CGAffineTransform(translationX: originY + CGFloat(side - 1), y: originX)
//var transform = CGAffineTransformConcat(storedTransform, translation)
//
//var coords: [((Int, Int), (Int, Int))] = []
//for y in 4..<8 {
//  for x in 11..<12 {
//    let transformed = CGPointApplyAffineTransform(CGPoint(x: x, y: y), transform)
//    coords.append(((x, y), (Int(transformed.x) + 12, Int(transformed.y) + 8)))
//  }
//}
//
//coords
