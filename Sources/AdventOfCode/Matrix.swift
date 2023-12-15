import Accelerate
import Algorithms

public struct Matrix {
  private(set) public var rows: Int
  private(set) public var columns: Int

  private(set) public var grid: [Double]

  public init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
    grid = Array(repeating: 0.0, count: rows * columns)
  }

  public init(_ items: [[Double]]) {
    if items.isEmpty || items.first!.isEmpty == true {
      self = Matrix(rows: 0, columns: 0)
      return
    }

    let rowCount = items.first!.count
    precondition(items.allSatisfy { $0.count == rowCount })
    self.rows = items.count
    self.columns = rowCount
    self.grid = Array(items.joined())
  }

  public subscript(row: Int, column: Int) -> Double {
    _read {
      checkValidSubscript(row: row, column: column)
      yield grid[(row * columns) + column]
    }
    _modify {
      checkValidSubscript(row: row, column: column)
      yield &grid[(row * columns) + column]
    }
  }

  // MARK: - Private

  @inlinable
  @inline(__always)
  internal func checkValidSubscript(row: Int, column: Int) {
    precondition(
      (row >= 0)
        && (row < rows)
        && (column >= 0)
        && (column < columns),
      "Index out of range"
    )
  }
}

extension Matrix: Equatable {
  public static func == (lhs: Matrix, rhs: Matrix) -> Bool {
    return lhs.grid == rhs.grid
  }
}

extension Matrix {
  public mutating func fill() {
    for i in (0..<rows * columns) {
      grid[i] = Double(i)
    }
  }
}

extension Matrix {
  public mutating func rotate(counterClockwise: Bool = false) {
    grid = [Double](unsafeUninitializedCapacity: grid.count) {
      buffer, unsafeUninitializedCapacity in
      vDSP_mtransD(grid, 1, buffer.baseAddress!, 1, vDSP_Length(columns), vDSP_Length(rows))
      swap(&rows, &columns)

      if counterClockwise {
        for column in 0..<columns {
          for row in 0..<(rows / 2) {
            buffer.swapAt(row * columns + column, (rows - 1 - row) * columns + column)
          }
        }
      } else {
        for row in 0..<rows {
          for column in 0..<(columns / 2) {
            buffer.swapAt(row * columns + column, row * columns + (columns - 1 - column))
          }
        }
      }

      unsafeUninitializedCapacity = grid.count
    }
  }
}

extension Matrix: CustomStringConvertible {
  public var description: String {
    "[\(Array(grid.chunks(ofCount: columns).map { Array($0) }))]"
  }
}
