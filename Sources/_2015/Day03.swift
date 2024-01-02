// MARK: Day 3: Perfectly Spherical Houses in a Vacuum -

import AdventOfCode
import Algorithms
import Foundation

struct Day03: AdventDay {
  // MARK: -

  func part1() -> Int {
    var visited: Set<Location> = [.zero]
    var pos = Location.zero
    for move in data { visit(location: &pos, move: move, visited: &visited) }

    return visited.count
  }

  func part2() -> Int {
    var visited: Set<Location> = [.zero]

    var pos = Location.zero
    for move in data.striding(by: 2) { visit(location: &pos, move: move, visited: &visited) }

    pos = .zero
    for move in data.dropFirst().striding(by: 2) {
      visit(location: &pos, move: move, visited: &visited)
    }

    return visited.count
  }

  // MARK: - Helpers

  func visit(location: inout Location, move: Character, visited: inout Set<Location>) {
    switch move {
    case "<": location.x -= 1
    case ">": location.x += 1
    case "^": location.y -= 1
    case "v": location.y += 1
    default: fatalError()
    }
    visited.insert(location)
  }

  // MARK: - Data

  let data: String

  init(data: String) { self.data = data.trimmingCharacters(in: .whitespacesAndNewlines) }

  // MARK: - Models

  struct Location: Hashable {
    var x, y: Int

    static var zero = Location(x: 0, y: 0)
  }
}
