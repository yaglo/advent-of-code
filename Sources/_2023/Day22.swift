// MARK: Day 22: Sand Slabs -

import AdventOfCode
import Collections

struct Day22: AdventDay {
  // MARK: -

  func part1() -> Int {
    var bricks = bricks
    fallDown(bricks: &bricks)
    return bricks.filter { $0.canBeDisintegrated(in: bricks) }.count
  }

  func part2() async -> Int {
    // Can be done with a graph, but brute force is also quick here
    await withTaskGroup(of: Int.self) { group in
      var bricks = bricks
      fallDown(bricks: &bricks)
      let preparedBricks = bricks

      for brick in bricks {
        group.addTask {
          var newBricks = preparedBricks
          newBricks.removeAll { brick.id == $0.id }
          return fallDown(bricks: &newBricks)
        }
      }

      return await group.reduce(0, +)
    }
  }

  @discardableResult func fallDown(bricks: inout [Brick]) -> Int {
    var numberOfFalls = 0
    for i in 0..<bricks.count {
      var brick = bricks[i]
      var fell = false
      while brick.z.lowerBound > 1 && !brick.collides(with: bricks) {
        brick = brick.fallingDownOnce
        fell = true
      }
      if fell { numberOfFalls += 1 }
      bricks[i] = brick
    }
    return numberOfFalls
  }

  // MARK: - Data

  let bricks: [Brick]

  init(data: String) {
    bricks = data.lines().enumerated()
      .map { index, line in
        let (lower, upper) = line.split(separator: "~").map { $0.integers(separatedBy: ",") }
          .splat()
        return Brick(
          id: index,
          x: lower[0]...upper[0],
          y: lower[1]...upper[1],
          z: lower[2]...upper[2]
        )
      }
      .sorted(by: \.z.upperBound)
  }

  // MARK: - Models

  struct Brick: CustomStringConvertible {
    let id: Int

    let x: ClosedRange<Int>
    let y: ClosedRange<Int>
    let z: ClosedRange<Int>

    var description: String {
      "\(id) \(x.lowerBound),\(y.lowerBound),\(z.lowerBound)~\(x.upperBound),\(y.upperBound),\(z.upperBound)"
    }

    func xyOverlaps(_ other: Brick) -> Bool { x.overlaps(other.x) && y.overlaps(other.y) }

    var fallingDownOnce: Brick {
      guard z.lowerBound > 1 else { return self }
      return Brick(id: id, x: x, y: y, z: z.lowerBound - 1...z.upperBound - 1)
    }

    func collides(with others: [Brick]) -> Bool {
      for other in others where other.id != id {
        if xyOverlaps(other) && z.lowerBound - 1 == other.z.upperBound { return true }
      }
      return false
    }

    func isSupported(by other: Brick) -> Bool {
      xyOverlaps(other) && z.lowerBound == other.z.upperBound + 1
    }

    func canBeDisintegrated(in bricks: [Brick]) -> Bool {
      !bricks.lazy.filter { $0.isSupported(by: self) }
        .contains { brick in !bricks.contains { $0.id != id && brick.isSupported(by: $0) } }
    }
  }
}
