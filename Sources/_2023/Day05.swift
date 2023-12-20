// MARK: Day 5: If You Give A Seed A Fertilizer -

import AdventOfCode

struct Day05: AdventDay {
  // MARK: -

  func part1() -> Int {
    seeds.map { seed in stages.reduce(seed) { value, stage in stage.transform(value) } }.min()!
  }

  func part2() -> Int {
    findRelevantLocationRanges(
      seedRanges: seeds.mapPairs { RangeMapping(sourceRange: $0..<$0 + $1) }
    )
    .map(\.destinationRange.lowerBound).min()!
  }

  // MARK: - Helpers

  func findRelevantLocationRanges(seedRanges: [RangeMapping]) -> [RangeMapping] {
    stages.reduce(seedRanges) { ranges, map in
      ranges.flatMap { range in
        let overlappingRanges = map.rangeMappings.filter {
          range.destinationRange.overlaps($0.sourceRange)
        }
        guard !overlappingRanges.isEmpty else {
          return [RangeMapping(sourceRange: range.destinationRange)]
        }
        return overlappingRanges.map { destination in
          RangeMapping(
            sourceRange: range.destinationRange.intersection(with: destination.sourceRange),
            destinationShift: destination.destinationShift
          )
        }
      }
    }
  }

  // MARK: - Data

  let seeds: [Int]
  let stages: [Stage]

  init(data: String) {
    let groups = data.split(separator: "\n\n")

    seeds = groups[0].drop { $0 != " " }.integers(separatedBy: " ")

    stages = groups.dropFirst()
      .map { group in
        Stage(
          rangeMappings: group.lines().dropFirst()
            .map { line in
              let (destination, source, count) = line.integers(separatedBy: " ").splat()
              return RangeMapping(
                sourceRange: source..<source + count,
                destinationShift: destination - source
              )
            }
        )
      }
  }

  // MARK: - Models

  struct RangeMapping: Hashable {
    let sourceRange: Range<Int>
    var destinationShift: Int = 0

    var destinationRange: Range<Int> {
      sourceRange.lowerBound + destinationShift..<sourceRange.upperBound + destinationShift
    }
  }

  struct Stage {
    let rangeMappings: [RangeMapping]

    init(rangeMappings: [RangeMapping]) {
      let sorted = rangeMappings.sorted { $0.sourceRange.lowerBound < $1.sourceRange.upperBound }
      var min = 0
      var ranges: [RangeMapping] = []
      for range in sorted {
        if min < range.sourceRange.lowerBound {
          ranges.append(RangeMapping(sourceRange: min..<range.sourceRange.lowerBound))
        }
        min = range.sourceRange.upperBound
        ranges.append(range)
      }
      self.rangeMappings = ranges
    }

    func transform(_ value: Int) -> Int {
      if let found = rangeMappings.first(where: { $0.sourceRange.contains(value) }) {
        value + found.destinationShift
      } else {
        value
      }
    }
  }
}
