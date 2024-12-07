public struct Coordinate: Sendable, Hashable {
  public var row: Int
  public var column: Int

  public init(row: Int, column: Int) {
    self.row = row
    self.column = column
  }

  public static func == (lhs: Coordinate, rhs: Coordinate) -> Bool {
    lhs.row == rhs.row && lhs.column == rhs.column
  }

  @inline(__always)
  public mutating func move(direction: Direction) {
    let delta = direction.delta
    self.row += delta.row
    self.column += delta.column
  }

  @inline(__always)
  public func value<T>(in grid: borrowing [[T]]) throws -> T {
    guard row >= 0 && row < grid.count && column >= 0 && column < grid[0].count else {
      throw CoordinateError.outOfBounds
    }
    return grid[row][column]
  }
}

enum CoordinateError: Error {
  case outOfBounds
}

public enum Direction: Sendable {
  case up, right, down, left

  public var delta: Coordinate {
    switch self {
    case .up: return Coordinate(row: -1, column: 0)
    case .right: return Coordinate(row: 0, column: 1)
    case .down: return Coordinate(row: 1, column: 0)
    case .left: return Coordinate(row: 0, column: -1)
    }
  }

  public var turningRight: Direction {
    switch self {
    case .up: return .right
    case .right: return .down
    case .down: return .left
    case .left: return .up
    }
  }

  public mutating func turnRight() {
    self = turningRight
  }
}
