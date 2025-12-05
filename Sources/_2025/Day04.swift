// MARK: Day 4: Printing Department -

import AdventOfCode

@Day struct Day04 {
    let grid: [[Bool]]

    init(data: String) {
        grid = data.mapLines { line in line.map { $0 == "@" } }
    }

    func part1() -> Int {
        grid.cells()
            .filter { $1 }
            .count { coord, _ in grid.neighbors(at: coord).count { $0 } < 4 }
    }

    func part2() -> Int {
        sequence(state: grid) { grid in
            let toRemove = grid.cells()
                .filter { $1 }
                .filter { coord, _ in grid.neighbors(at: coord).count { $0 } < 4 }
                .map(\.coord)
            guard !toRemove.isEmpty else { return nil }
            for coord in toRemove { grid[coord] = false }
            return toRemove.count
        }.sum()
    }
}
