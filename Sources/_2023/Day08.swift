// MARK: Day 8: Haunted Wasteland -

import AdventOfCode
import Algorithms

struct Day08: AdventDay {
  // MARK: -

  func part1() -> Int {
    numberOfSteps(from: "AAA")
  }

  func part2() -> Int {
    nodes
      .keys
      .filter { $0.hasSuffix("A") }
      .map(numberOfSteps(from:))
      .reduce(with: lcm)
  }

  // MARK: - Helpers

  func numberOfSteps(from nodeID: String) -> Int {
    var currentID = nodeID
    for (step, instruction) in instructions.cycled().enumerated() {
      currentID = nodes[currentID]![keyPath: instruction]
      if currentID.hasSuffix("Z") {
        return step + 1
      }
    }
    fatalError()
  }

  // MARK: - Data

  struct Node {
    let id, left, right: String
  }

  let instructions: [KeyPath<Node, String>]
  let nodes: [String: Node]

  init(data: String) {
    let lines = data.lines()

    instructions = lines[0].map { $0 == "L" ? \.left : \.right }

    nodes =
      lines
      .dropFirst()
      .map { line in
        line
          .matches(of: /[0-9A-Z]{3}/)
          .map(\.output)
          .map(String.init)
          .splat(Node.init)
      }
      .keyed(by: \.id)
  }
}
