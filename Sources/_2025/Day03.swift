// MARK: Day 3: Lobby -

import AdventOfCode

@Day struct Day03 {
    // MARK: -

    func part1() -> Int {
        lines.map { digits in
            let ten = digits.dropLast().max()!
            let one = digits.drop { $0 != ten }.dropFirst().max()!
            return ten * 10 + one
        }.sum()
    }

    func part2() -> Int {
        lines.map { digits in
            func findLargest(_ digits: ArraySlice<Int>, _ remaining: Int, _ acc: Int) -> Int {
                guard remaining > 0 else { return acc }
                let range = digits.dropLast(remaining - 1)
                let max = range.max()!
                let idx = range.firstIndex(of: max)!
                return findLargest(digits[(idx + 1)...], remaining - 1, acc * 10 + max)
            }
            return findLargest(digits[...], 12, 0)
        }.sum()
    }

    // MARK: - Data

    let lines: [[Int]]

    init(data: String) {
        lines = data.mapLines { $0.compactMap(\.wholeNumberValue) }
    }

}
