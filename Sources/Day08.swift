struct Day08: AdventDay {
  // MARK: -

  func part1() -> Int {
    numberOfSteps(from: "AAA")
  }

  func part2() -> Int {
    nodes.keys.filter { $0.hasSuffix("A") }
      .map { numberOfSteps(from: $0) }
      .collapse(with: lcm)
  }

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

  typealias Node = (left: String, right: String)

  let instructions: [KeyPath<Node, String>]
  let nodes: [String: Node]

  init(data: String) {
    let lines = data.lines()

    instructions = lines[0].map { $0 == "L" ? \.left : \.right }

    nodes = Dictionary(
      lines
        .dropFirst()
        .map {
          $0.matches(of: /[0-9A-Z]{3}/)
            .map(\.output)
            .map(String.init)
            .splat { ($0, (left: $1, right: $2)) }
        }, uniquingKeysWith: { first, _ in first })
  }
}
