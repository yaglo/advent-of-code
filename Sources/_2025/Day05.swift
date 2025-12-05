// MARK: Day 5 -

import AdventOfCode

@Day struct Day05 {
    let ranges: RangeSet<Int>
    let ids: [Int]

    init(data: String) {
        let (rangeList, idList) = data.split(separator: "\n\n").splat()
        ranges = RangeSet(rangeList.mapLines { $0.integers(separatedBy: "-").splat { $0..<$1 + 1 } })
        ids = idList.integers(separatedBy: "\n")
    }

    func part1() -> Int {
        ids.count(where: ranges.contains)
    }

    func part2() -> Int {
        ranges.ranges.map(\.count).sum()
    }
}
