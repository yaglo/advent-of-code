import Algorithms

// MARK: - Grid (2D Array) Extensions

public struct GridSequence<Grid: RandomAccessCollection>: Sequence
where Grid.Element: RandomAccessCollection, Grid.Index == Int, Grid.Element.Index == Int {
    public let grid: Grid
    @usableFromInline let rows: Int
    @usableFromInline let cols: Int

    @inlinable
    public init(_ grid: Grid) {
        self.grid = grid
        self.rows = grid.count
        self.cols = grid.isEmpty ? 0 : grid[0].count
    }

    public struct Iterator: IteratorProtocol {
        @usableFromInline let grid: Grid
        @usableFromInline let rows: Int
        @usableFromInline let cols: Int
        @usableFromInline var row = 0
        @usableFromInline var col = 0

        @inlinable
        init(_ grid: Grid, rows: Int, cols: Int) {
            self.grid = grid
            self.rows = rows
            self.cols = cols
        }

        @inlinable
        public mutating func next() -> (coord: Coordinate, value: Grid.Element.Element)? {
            guard row < rows else { return nil }
            let result = (Coordinate(row: row, column: col), grid[row][col])
            col += 1
            if col >= cols {
                col = 0
                row += 1
            }
            return result
        }
    }

    @inlinable
    public func makeIterator() -> Iterator { Iterator(grid, rows: rows, cols: cols) }
}

extension GridSequence {
    @inlinable
    public func filter(
        _ isIncluded: @escaping (Coordinate, Grid.Element.Element) -> Bool
    ) -> FilteredGridSequence<Grid> {
        FilteredGridSequence(grid, rows: rows, cols: cols, predicate: isIncluded)
    }

    @inlinable
    public func filter(
        _ isIncluded: @escaping (Grid.Element.Element) -> Bool
    ) -> FilteredGridSequence<Grid> {
        FilteredGridSequence(grid, rows: rows, cols: cols, predicate: { _, v in isIncluded(v) })
    }

    @inlinable
    public func count(where predicate: (Coordinate, Grid.Element.Element) -> Bool) -> Int {
        var count = 0
        for row in 0..<rows {
            for col in 0..<cols {
                if predicate(Coordinate(row: row, column: col), grid[row][col]) { count += 1 }
            }
        }
        return count
    }

    @inlinable
    public func count(where predicate: (Grid.Element.Element) -> Bool) -> Int {
        var count = 0
        for row in 0..<rows {
            for col in 0..<cols {
                if predicate(grid[row][col]) { count += 1 }
            }
        }
        return count
    }
}

public struct FilteredGridSequence<Grid: RandomAccessCollection>: Sequence
where Grid.Element: RandomAccessCollection, Grid.Index == Int, Grid.Element.Index == Int {
    @usableFromInline let grid: Grid
    @usableFromInline let rows: Int
    @usableFromInline let cols: Int
    @usableFromInline let predicate: (Coordinate, Grid.Element.Element) -> Bool

    @inlinable
    init(_ grid: Grid, rows: Int, cols: Int, predicate: @escaping (Coordinate, Grid.Element.Element) -> Bool) {
        self.grid = grid
        self.rows = rows
        self.cols = cols
        self.predicate = predicate
    }

    public struct Iterator: IteratorProtocol {
        @usableFromInline let grid: Grid
        @usableFromInline let rows: Int
        @usableFromInline let cols: Int
        @usableFromInline let predicate: (Coordinate, Grid.Element.Element) -> Bool
        @usableFromInline var row = 0
        @usableFromInline var col = 0

        @inlinable
        init(_ grid: Grid, rows: Int, cols: Int, predicate: @escaping (Coordinate, Grid.Element.Element) -> Bool) {
            self.grid = grid
            self.rows = rows
            self.cols = cols
            self.predicate = predicate
        }

        @inlinable
        public mutating func next() -> (coord: Coordinate, value: Grid.Element.Element)? {
            while row < rows {
                let coord = Coordinate(row: row, column: col)
                let value = grid[row][col]
                col += 1
                if col >= cols {
                    col = 0
                    row += 1
                }
                if predicate(coord, value) { return (coord, value) }
            }
            return nil
        }
    }

    @inlinable
    public func makeIterator() -> Iterator { Iterator(grid, rows: rows, cols: cols, predicate: predicate) }

    @inlinable
    public func count(where additionalPredicate: (Coordinate, Grid.Element.Element) -> Bool) -> Int {
        var count = 0
        for row in 0..<rows {
            for col in 0..<cols {
                let coord = Coordinate(row: row, column: col)
                let value = grid[row][col]
                if predicate(coord, value) && additionalPredicate(coord, value) { count += 1 }
            }
        }
        return count
    }

    @inlinable
    public func count(where additionalPredicate: (Grid.Element.Element) -> Bool) -> Int {
        var count = 0
        for row in 0..<rows {
            for col in 0..<cols {
                let value = grid[row][col]
                if predicate(Coordinate(row: row, column: col), value) && additionalPredicate(value) { count += 1 }
            }
        }
        return count
    }

    @inlinable
    public func map<T>(_ transform: (Coordinate, Grid.Element.Element) -> T) -> [T] {
        var result: [T] = []
        for row in 0..<rows {
            for col in 0..<cols {
                let coord = Coordinate(row: row, column: col)
                let value = grid[row][col]
                if predicate(coord, value) { result.append(transform(coord, value)) }
            }
        }
        return result
    }

    @inlinable
    public var coords: [Coordinate] {
        var result: [Coordinate] = []
        for row in 0..<rows {
            for col in 0..<cols {
                let coord = Coordinate(row: row, column: col)
                if predicate(coord, grid[row][col]) { result.append(coord) }
            }
        }
        return result
    }

    @inlinable
    public func coords(where additionalPredicate: (Coordinate) -> Bool) -> [Coordinate] {
        var result: [Coordinate] = []
        for row in 0..<rows {
            for col in 0..<cols {
                let coord = Coordinate(row: row, column: col)
                if predicate(coord, grid[row][col]) && additionalPredicate(coord) { result.append(coord) }
            }
        }
        return result
    }
}

// MARK: - Neighbor Iteration

public struct NeighborSequence<T>: Sequence, IteratorProtocol {
    @usableFromInline let grid: [[T]]
    @usableFromInline let row: Int
    @usableFromInline let col: Int
    @usableFromInline let rows: Int
    @usableFromInline let cols: Int
    @usableFromInline var dr = -1
    @usableFromInline var dc = -1

    @inlinable
    init(_ grid: [[T]], at coord: Coordinate) {
        self.grid = grid
        self.row = coord.row
        self.col = coord.column
        self.rows = grid.count
        self.cols = grid[0].count
    }

    @inlinable
    public mutating func next() -> T? {
        while dr <= 1 {
            while dc <= 1 {
                let currentDr = dr
                let currentDc = dc
                dc += 1
                if currentDr == 0 && currentDc == 0 { continue }
                let nr = row + currentDr
                let nc = col + currentDc
                if nr >= 0 && nr < rows && nc >= 0 && nc < cols {
                    return grid[nr][nc]
                }
            }
            dc = -1
            dr += 1
        }
        return nil
    }
}

// MARK: - Grid Array Extensions

extension Array where Element: RandomAccessCollection, Element.Index == Int {
    @inlinable
    public func cells() -> GridSequence<Self> { GridSequence(self) }

    @inlinable
    public subscript(coord: Coordinate) -> Element.Element
    where Element: MutableCollection {
        get { self[coord.row][coord.column] }
        set { self[coord.row][coord.column] = newValue }
    }
}

extension Array {
    @inlinable
    public func neighbors<T>(at coord: Coordinate) -> NeighborSequence<T> where Element == [T] {
        NeighborSequence(self, at: coord)
    }
}

// MARK: - Rotation

extension Array {
    /// Generic rotation for any 2D array - O(n*m) time and space
    @inlinable
    public mutating func rotate<T>(counterClockwise: Bool = false) where Element == [T] {
        let rows = count
        guard rows > 0 else { return }
        let cols = self[0].count
        guard cols > 0 else { return }

        var result = [[T]](
            repeating: [T](repeating: self[0][0], count: rows),
            count: cols
        )

        if counterClockwise {
            // (r, c) -> (cols - 1 - c, r)
            for r in 0..<rows {
                for c in 0..<cols {
                    result[cols - 1 - c][r] = self[r][c]
                }
            }
        } else {
            // (r, c) -> (c, rows - 1 - r)
            for r in 0..<rows {
                for c in 0..<cols {
                    result[c][rows - 1 - r] = self[r][c]
                }
            }
        }
        self = result
    }
}
