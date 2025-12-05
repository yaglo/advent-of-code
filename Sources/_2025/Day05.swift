// MARK: Day 5 -

import AdventOfCode

@Day struct Day05 {
    let ranges: RangeSet<Int>
    let ids: [Int]

    init(data: String) {
        let parts = data.split(separator: "\n\n")
        ranges = parts[0].lines().reduce(into: RangeSet()) { set, line in
            let bounds = line.split(separator: "-").map { Int($0)! }
            set.insert(contentsOf: bounds[0]..<bounds[1] + 1)
        }
        ids = parts[1].lines().map { Int($0)! }
    }

    func part1() -> Int {
        ids.count(where: ranges.contains)
    }

    func part2() -> Int {
        ranges.ranges.map(\.count).sum()
    }
}
