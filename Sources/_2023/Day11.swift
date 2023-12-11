// MARK: Day 11: Cosmic Expansion -

import AdventOfCode
import Algorithms

struct Day11: AdventDay {
  // MARK: -

  func part1() -> Int {
    galaxies.combinations(ofCount: 2).map { galaxies in
      distance(galaxy1: galaxies[0], galaxy2: galaxies[1], expansionMultiplier: 1)
    }.sum()
  }

  func part2() -> Int {
    galaxies.combinations(ofCount: 2).map { galaxies in
      distance(galaxy1: galaxies[0], galaxy2: galaxies[1], expansionMultiplier: 999999)
    }.sum()
  }

  // MARK: - Helpers

  func distance(galaxy1: Galaxy, galaxy2: Galaxy, expansionMultiplier: Int) -> Int {
    let xs = [galaxy1.x, galaxy2.x].sorted()
    let ys = [galaxy1.y, galaxy2.y].sorted()
    let xRange = xs[0]...xs[1]
    let yRange = ys[0]...ys[1]
    let xExpansions = emptyColumns.filter { xRange.contains($0) }.count
    let yExpansions = emptyRows.filter { yRange.contains($0) }.count
    return (xRange.upperBound - xRange.lowerBound + xExpansions * expansionMultiplier)
      + (yRange.upperBound - yRange.lowerBound + yExpansions * expansionMultiplier)
  }

  // MARK: - Data

  struct Galaxy: Hashable {
    let x, y: Int
  }

  let galaxies: Set<Galaxy>
  let emptyColumns: Set<Int>
  let emptyRows: Set<Int>

  init(data: String) {
    let data = data.mapLines { Array($0) }

    emptyRows = Set(
      data
        .enumerated()
        .filter { $1.allSatisfy { $0 == "." } }
        .map(\.offset)
    )

    emptyColumns = Set(
      data[0]
        .indices
        .filter { data[column: $0].allSatisfy { $0 == "." } }
    )

    self.galaxies = Set(
      data.enumerated().flatMap { y, line in
        line.enumerated().compactMap { x, character in
          character == "#" ? Galaxy(x: x, y: y) : nil
        }
      })
  }
}
