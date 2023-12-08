struct Day08: AdventDay {
  // MARK: -

  func part1() -> Int {
    numberOfSteps(from: "AAA")
  }

  func part2() -> Int {
    ghostStartPositions
      .map { numberOfSteps(from: $0) }
      .collapse(with: lcm)
  }

  func numberOfSteps(from nodeID: String) -> Int {
    var steps = 0
    var currentID = nodeID
    while true {
      for instruction in instructions {
        steps += 1
        let currentNode = nodeNetwork[currentID]!
        currentID =
          if instruction == "L" {
            currentNode.left
          } else {
            currentNode.right
          }
        if currentID.last == "Z" {
          return steps
        }
      }
    }
  }

  // MARK: - Data

  let instructions: String
  let nodeNetwork: [String: Node]
  let ghostStartPositions: [String]

  init(data: String) {
    let lines = data.lines()
    instructions = String(lines[0])

    var nodes: [String: Node] = [:]
    var ghostStartPositions: [String] = []

    for line in lines.dropFirst() {
      let components = line.matches(of: /[0-9A-Z]{3}/).map { String($0.output) }
      let nodeID = components[0]
      nodes[nodeID] = Node(left: components[1], right: components[2])
      if nodeID.last == "A" {
        ghostStartPositions.append(nodeID)
      }
    }
    self.nodeNetwork = nodes
    self.ghostStartPositions = ghostStartPositions
  }

  // MARK: - Models

  struct Node {
    let left: String
    let right: String
  }
}
