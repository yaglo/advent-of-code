// MARK: Day 1: Calorie Counting -

import AdventOfCode

@Day struct Day01 {
    // MARK: -

    func part1() -> Int { calculateCaloriesPerElf().max()! }

    func part2() -> Int { calculateCaloriesPerElf().sorted(by: >).prefix(3).sum() }

    func calculateCaloriesPerElf() -> [Int] {
        data.split(separator: "\n\n").map { String($0).lines().sum { Int($0)! } }
    }
}
