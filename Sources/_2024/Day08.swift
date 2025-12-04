// MARK: Day 8: Resonant Collinearity -

import AdventOfCode
import Collections

@Day struct Day08 {
    // MARK: -

    func part1() -> Int {
        countAntinodes(includeHarmonics: false)
    }

    func part2() -> Int {
        countAntinodes(includeHarmonics: true)
    }

    func countAntinodes(includeHarmonics: Bool) -> Int {
        antennas.values.map { coordinates in
            coordinates.combinations(ofCount: 2).flatMap { pair in
                generateNodes(pair: pair, includeHarmonics: includeHarmonics)
            }
        }
        .reduce(into: Set<Coordinate>()) { $0.formUnion($1) }
        .count { includeHarmonics || isValid(row: $0.row, column: $0.column) }
    }

    func isValid(row: Int, column: Int) -> Bool {
        row >= 0 && column >= 0 && row < size.row && column < size.column
    }

    func generateNodes(pair: [Coordinate], includeHarmonics: Bool) -> [Coordinate] {
        let deltaRow = pair[0].row - pair[1].row
        let deltaColumn = pair[0].column - pair[1].column

        return if includeHarmonics {
            generateHarmonics(deltaRow: deltaRow, deltaColumn: deltaColumn, from: pair[0])
                + generateHarmonics(deltaRow: deltaRow, deltaColumn: deltaColumn, from: pair[1])
        } else {
            [
                Coordinate(row: pair[0].row + deltaRow, column: pair[0].column + deltaColumn),
                Coordinate(row: pair[0].row - deltaRow, column: pair[0].column - deltaColumn),
                Coordinate(row: pair[1].row + deltaRow, column: pair[1].column + deltaColumn),
                Coordinate(row: pair[1].row - deltaRow, column: pair[1].column - deltaColumn),
            ].filter { !pair.contains($0) }
        }
    }

    func generateHarmonics(deltaRow: Int, deltaColumn: Int, from: Coordinate) -> [Coordinate] {
        var nodes = [Coordinate]()
        var row = from.row + deltaRow
        var column = from.column + deltaColumn

        while isValid(row: row, column: column) {
            nodes.append(Coordinate(row: row, column: column))
            row += deltaRow
            column += deltaColumn
        }

        row = from.row - deltaRow
        column = from.column - deltaColumn

        while isValid(row: row, column: column) {
            nodes.append(Coordinate(row: row, column: column))
            row -= deltaRow
            column -= deltaColumn
        }

        return nodes
    }

    // MARK: - Data

    let antennas: [Character: [Coordinate]]
    let size: Coordinate

    init(data: String) {
        let lines = data.lines()
        var antennas: [Character: [Coordinate]] = [:]
        for (row, line) in lines.enumerated() {
            for (column, character) in line.enumerated() where character != "." {
                antennas[character, default: []].append(Coordinate(row: row, column: column))
            }
        }
        self.antennas = antennas
        self.size = Coordinate(row: lines.count, column: lines.first!.count)
    }
}
