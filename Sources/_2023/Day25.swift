// MARK: Day 24: Never Tell Me The Odds -

import AdventOfCode
import Foundation
import PythonKit

struct Day25: AdventDay {
  // MARK: -

  func part1() -> Int {
    let minCutSet = Set(findGlobalMinCutNodes(adjacencyMatrix).nodes)
    return minCutSet.count * nodes.subtracting(minCutSet).count
  }

  func findGlobalMinCutNodes(_ adjacencyMatrix: [[Int]]) -> CutResult {
    var adj = adjacencyMatrix
    var optimalCut = CutResult(weight: Int.max, nodes: [])
    let nodeCount = adj.count

    var combinedVertices = (0..<nodeCount).map { [$0] }

    for phase in 1..<nodeCount {
      var weights = adj[0]
      var s = 0
      var t = 0
      for _ in 0..<nodeCount - phase {
        weights[t] = Int.min
        s = t
        t = weights.enumerated().max(by: { $0.element < $1.element })!.offset
        for i in 0..<nodeCount { weights[i] += adj[t][i] }
      }

      let currentWeight = weights[t] - adj[t][t]

      if currentWeight < optimalCut.weight {
        optimalCut = CutResult(weight: currentWeight, nodes: Set(combinedVertices[t]))
      }

      combinedVertices[s].append(contentsOf: combinedVertices[t])

      for i in 0..<nodeCount {
        adj[s][i] += adj[t][i]
        adj[i][s] = adj[s][i]
      }
      adj[0][t] = Int.min
    }

    return optimalCut
  }
  
  struct CutResult: Comparable {
    static func < (lhs: CutResult, rhs: CutResult) -> Bool {
      lhs.weight < rhs.weight
    }

    let weight: Int
    let nodes: Set<Int>
  }

  func part2() -> Int { 0 }

  let adjacencyMatrix: [[Int]]
  let nodes: Set<Int>

  init(data: String) {
    var nodes: Set<Substring> = []
    var edges: Set<[Substring]> = []

    data.enumerateLines { line, _ in
      let (source, other) = line.split(separator: ": ").splat()
      for target in other.split(separator: " ") {
        nodes.insert(source)
        nodes.insert(target)
        edges.insert([source, target])
      }
    }

    var nodeMap: [Substring: Int] = [:]
    for (i, node) in nodes.enumerated() { nodeMap[node] = i }

    var adjacencyMatrix: [[Int]] = [[Int]](
      repeating: [Int](repeating: 0, count: nodeMap.count),
      count: nodeMap.count
    )
    for edge in edges {
      let src = nodeMap[edge[0]]!
      let dst = nodeMap[edge[1]]!
      adjacencyMatrix[src][dst] = 1
      adjacencyMatrix[dst][src] = 1
    }

    self.adjacencyMatrix = adjacencyMatrix
    self.nodes = Set(nodeMap.values.map { $0 })
  }
}
