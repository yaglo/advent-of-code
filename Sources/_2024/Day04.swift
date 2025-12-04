// MARK: Day 4: Ceres Search -

import AdventOfCode

@Day struct Day04 {
    // MARK: -

    func part1() -> Int {
        grid.indices.sum { y in
            grid[y].indices.sum { x in
                [(0, 1), (1, 0), (-1, 0), (0, -1), (1, 1), (-1, 1), (-1, -1), (1, -1)].count { dy, dx in
                    Array("XMAS").enumerated().allSatisfy {
                        grid[safe: y + $0.offset * dy]?[safe: x + $0.offset * dx] == $0.element
                    }
                }
            }
        }
    }

    func part2() -> Int {
        let masOrSam = [Array("MS"), Array("SM")]
        return (1..<grid.count - 1)
            .sum { y in
                (1..<grid[y].count - 1)
                    .count { x in
                        guard grid[y][x] == "A" else { return false }
                        return masOrSam.contains([grid[y - 1][x - 1], grid[y + 1][x + 1]])
                            && masOrSam.contains([grid[y + 1][x - 1], grid[y - 1][x + 1]])
                    }
            }
    }

    // MARK: - Data

    let grid: [[Character]]

    init(data: String) { grid = data.mapLines(Array.init) }
}
