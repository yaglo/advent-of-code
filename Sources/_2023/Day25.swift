// MARK: Day 24: Never Tell Me The Odds -

import AdventOfCode
import Foundation
import PythonKit

struct Day25: AdventDay {
  // MARK: -

  func part1() -> Int {
    let nx = Python.import("networkx")
    let graph = nx.Graph()

    data.enumerateLines { line, _ in
      let (source, destination) = line.split(separator: ": ").splat()
      for target in destination.split(separator: " ") {
        graph.add_edge(String(source), String(target))
      }
    }

    let result = nx.stoer_wagner(graph)
    return result[1][0].count * result[1][1].count
  }

  func part2() -> Int {
    0
  }

  let data: String
}
