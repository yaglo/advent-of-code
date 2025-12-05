// MARK: Day 5 -

import AdventOfCode

@Day struct Day05 {
    let ranges: RangeSet<Int>
    let ids: [Int]

    init(data: String) {
        let parts = data.split(separator: "\n\n")
        var rangeSet = RangeSet<Int>()
        for line in parts[0].lines() {
            let (lo, hi) = line.integers(separatedBy: "-").splat()
            rangeSet.insert(contentsOf: lo..<hi + 1)
        }
        ranges = rangeSet

        ids = parts[1].integers(separatedBy: "\n")
    }

    func part1() -> Int {
        ids.count(where: ranges.contains)
    }

    func part2() -> Int {
        ranges.ranges.map(\.count).sum()
    }
}
