import Foundation

struct Day8: Day {
    let instructions: String
    let nodeNetwork: [String: Node]
    let ghostStartPositions: [String]

    func part1() -> Int {
        numberOfSteps(from: "AAA")
    }

    func part2() -> Int {
        let steps = ghostStartPositions.map { numberOfSteps(from: $0) }
        return steps.dropFirst().reduce(steps.first!, lcm)
    }

    func numberOfSteps(from node: String) -> Int {
        var steps = 0
        var current = node
        while true {
            for instruction in instructions {
                steps += 1
                current =
                    if instruction == "L" {
                        nodeNetwork[current]!.left
                    } else {
                        nodeNetwork[current]!.right
                    }
                if current.last == "Z" {
                    return steps
                }
            }
        }
    }

    init(_ input: String) {
        let lines = input.split(whereSeparator: \.isNewline)
        instructions = String(lines[0])

        var nodes: [String: Node] = [:]
        var ghostStartPositions: [String] = []
        lines
            .dropFirst()
            .forEach {
                let components = $0.matches(of: /[A-Z]{3}/).map { String($0.output) }
                let nodeID = components[0]
                nodes[nodeID] = Node(left: components[1], right: components[2])
                if nodeID.last == "A" {
                    ghostStartPositions.append(nodeID)
                }
            }
        self.nodeNetwork = nodes
        self.ghostStartPositions = ghostStartPositions
    }

    struct Node {
        let left: String
        let right: String
    }
}
