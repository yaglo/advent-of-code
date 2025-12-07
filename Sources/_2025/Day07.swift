// MARK: Day 7: Laboratories -

import AdventOfCode

@Day struct Day07 {
    let grid: [[Character]]

    init(data: String) {
        grid = data.mapLines { Array($0) }
    }

    func simulate() -> (splits: Int, paths: Int) {
        var beamCounts = [grid[0].firstIndex(of: "S")!: 1]
        var splits = 0

        for row in 1..<grid.count {
            var newCounts = [Int: Int]()
            for (column, count) in beamCounts {
                if grid[row][column] == "^" {
                    splits += 1
                    newCounts[column - 1, default: 0] += count
                    newCounts[column + 1, default: 0] += count
                } else {
                    newCounts[column, default: 0] += count
                }
            }
            beamCounts = newCounts
        }

        return (splits, beamCounts.sum(of: \.value))
    }

    func part1() -> Int {
        simulate().splits
    }

    func part2() -> Int {
        simulate().paths
    }
}
