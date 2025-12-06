// MARK: Day 6: Trash Compactor -

import AdventOfCode

@Day struct Day06 {
    func part1() -> Int {
        let lines = data.lines()
        let operators = lines.last!.split(whereSeparator: \.isWhitespace)

        var operands = lines.dropLast().map(\.integers)
        operands.rotate()

        return zip(operators, operands).map { op, nums in
            op == "+" ? nums.sum() : nums.product()
        }.sum()
    }

    func part2() -> Int {
        let lines = data.lines()
        let operators = lines.last!.split(whereSeparator: \.isWhitespace).reversed()

        let grid = lines.dropLast().map { Array($0) }

        let nums = (0..<grid[0].count)
            .reversed()
            .map { String(grid[column: $0]).integers.first }

        let operands = nums.split(separator: nil).map { $0.compacted() }

        return zip(operators, operands).map { op, nums in
            op == "+" ? nums.sum() : nums.product()
        }.sum()
    }
}
