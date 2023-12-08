import Algorithms
import Foundation

struct Day5: Day {
    let seeds: [Int]
    let stages: [Stage]

    struct RangeMapping: Hashable {
        let sourceRange: Range<Int>
        let destinationShift: Int

        var destinationRange: Range<Int> {
            sourceRange.lowerBound + destinationShift..<sourceRange.upperBound + destinationShift
        }
    }

    struct Stage {
        let rangeMappings: [RangeMapping]

        func transform(_ value: Int) -> Int {
            if let found = rangeMappings.first(where: { $0.sourceRange.contains(value) }) {
                value + found.destinationShift
            } else {
                value
            }
        }
    }

    func part1() -> Int {
        seeds.map { seed in
            stages.reduce(seed) { value, stage in
                stage.transform(value)
            }
        }.min()!
    }

    func part2() -> Int {
        let seedRanges = seeds.chunks(ofCount: 2).map { seedPair in
            RangeMapping(sourceRange: seedPair.first!..<seedPair.first! + seedPair.last!, destinationShift: 0)
        }
        return stages.reduce(seedRanges) { ranges, map in
            ranges.flatMap { range in
                let overlappingRanges = map.rangeMappings.filter {
                    range.destinationRange.overlaps($0.sourceRange)
                }
                return if overlappingRanges.isEmpty {
                    [RangeMapping(sourceRange: range.destinationRange, destinationShift: 0)]
                } else {
                    overlappingRanges.map {
                        RangeMapping(
                            sourceRange: range.destinationRange.intersection(with: $0.sourceRange),
                            destinationShift: $0.destinationShift
                        )
                    }
                }
            }
        }.map { $0.destinationRange.lowerBound }.min()!
    }

    init(_ input: String) {
        let groups = input.split(separator: "\n\n")

        seeds = groups[0]
            .drop { $0 != " " }
            .split(separator: " ")
            .map { Int($0)! }

        stages =
            groups
            .dropFirst()
            .map {
                Stage(
                    rangeMappings:
                        $0
                        .split(whereSeparator: \.isNewline)
                        .dropFirst()
                        .map { line in
                            let parts = line.split(separator: " ").map { Int($0)! }
                            let (destination, source, count) = (parts[0], parts[1], parts[2])
                            return RangeMapping(sourceRange: source..<source + count, destinationShift: destination - source)
                        }
                )
            }
    }
}
