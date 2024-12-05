// MARK: Day 2: I Was Told There Would Be No Math -

import AdventOfCode
import Foundation

struct Day02: AdventDay {
  // MARK: -

  func part1() -> Int {
    dimensions.sum { (l, w, h) in
      let lw = l * w
      let wh = w * h
      let hl = h * l
      let min = min(lw, wh, hl)
      return 2 * (lw + wh + hl) + min
    }
  }

  func part2() -> Int {
    dimensions.sum { l, w, h in
      let wrapping = [l, w, h].combinations(ofCount: 2).map { 2 * ($0[0] + $0[1]) }.min()!
      let bow = (l * w * h)
      return wrapping + bow
    }
  }

  // MARK: - Data

  let dimensions: [(Int, Int, Int)]

  init(data: String) {
    dimensions = data.mapLines { line in line.integers(separatedBy: "x").splat() }
  }
}
