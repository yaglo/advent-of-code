// MARK: Day 23: A Long Walk -

import AdventOfCode
import Collections

struct Day23: AdventDay {
  // MARK: -

  func part1() -> Int {
    let (edges, start, end) = buildGraph(directed: true)
    return findLongestPath(edges: edges, from: start, to: end)

    func findLongestPath(edges: [NodePair: Int], from source: Node, to target: Node) -> Int {
      let topologicalOrder = topologicalSort(nodes: [source])

      var distances: [Int: Int] = [:]
      for edge in edges {
        distances[edge.key.source] = Int.min
        distances[edge.key.target] = Int.min
      }

      distances[source.id] = 0

      for node in topologicalOrder {
        if let distance = distances[node.id], distance != Int.min {
          for edge in edges where edge.key.source == node.id {
            if let nextDistance = distances[edge.key.target] {
              distances[edge.key.target] = max(nextDistance, distance + edge.value)
            }
          }
        }
      }

      return distances[target.id] ?? Int.min
    }

    func topologicalSort(nodes: [Node]) -> [Node] {
      var visited: Set<Int> = []
      var stack: [Node] = []

      for node in nodes { if !visited.contains(node.id) { dfs(node, &visited, &stack) } }

      return stack.reversed()
    }

    func dfs(_ node: Node, _ visited: inout Set<Int>, _ stack: inout [Node]) {
      visited.insert(node.id)
      for adjacent in node.adjacents {
        if !visited.contains(adjacent.id) { dfs(adjacent, &visited, &stack) }
      }
      stack.append(node)
    }
  }

  func part2() -> Int {
    let (edges, start, end) = buildGraph(directed: false)
    return findLongestPath(from: start, to: end)

    func findLongestPath(from start: Node, to end: Node) -> Int {
      var visited: Set<Node> = []
      var maxPathLength = 0

      func dfs(current: Node, pathLength: Int) {
        if current == end {
          maxPathLength = max(maxPathLength, pathLength)
          return
        }

        visited.insert(current)

        for adjacent in current.adjacents {
          if !visited.contains(adjacent) {
            let edgeWeight = edges[NodePair(source: current.id, target: adjacent.id)] ?? 0
            dfs(current: adjacent, pathLength: pathLength + edgeWeight)
          }
        }

        visited.remove(current)
      }

      dfs(current: start, pathLength: 0)
      return maxPathLength
    }
  }

  // MARK: - Models

  struct Coordinate: Hashable, CustomStringConvertible {
    let x, y: Int

    var description: String { "(\(x),\(y))" }

    static func + (lhs: Coordinate, rhs: Coordinate) -> Coordinate {
      Coordinate(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }

    var reversed: Coordinate { Coordinate(x: -x, y: -y) }

    var isValidStep: Bool {
      map.indices.contains(y) && map[0].indices.contains(x) && character != "#"
    }

    var character: Character { map[y][x] }

    var characterDirection: Coordinate {
      switch character {
      case "<": Coordinate(x: -1, y: 0)
      case ">": Coordinate(x: 1, y: 0)
      case "^": Coordinate(x: 0, y: -1)
      case "v": Coordinate(x: 0, y: 1)
      default: fatalError("Unknown direction \(character) at position \(self)")
      }
    }
  }

  class Node: CustomStringConvertible, Hashable {
    var id: Int
    var coordinate: Coordinate
    var adjacents: Set<Node> = []

    init(id: Int? = nil, coordinate: Coordinate) {
      if let id {
        self.id = id
      } else {
        self.id = idIndex
        idIndex += 1
      }
      self.coordinate = coordinate
    }

    var description: String { "Node \(id) (coordinate: \(coordinate))" }

    static func == (lhs: Day23.Node, rhs: Day23.Node) -> Bool { lhs.id == rhs.id }

    func hash(into hasher: inout Hasher) { hasher.combine(id) }
  }

  class Walker {
    var directed: Bool
    var coordinate: Coordinate
    var direction: Coordinate
    var steps = 1
    var startNodeCoordinate: Coordinate

    var visited: [Coordinate] = []

    var validDirections: [Coordinate] {
      var directions = Set([
        Coordinate(x: -1, y: 0), Coordinate(x: 1, y: 0), Coordinate(x: 0, y: -1),
        Coordinate(x: 0, y: 1),
      ])
      directions.remove(direction.reversed)
      return directions.filter { ($0 + coordinate).isValidStep }
    }

    init(
      directed: Bool,
      coordinate: Coordinate,
      direction: Coordinate,
      startNodeCoordinate: Coordinate
    ) {
      self.directed = directed
      self.direction = direction
      self.coordinate = coordinate
      self.startNodeCoordinate = startNodeCoordinate
    }

    func walkUntilJunction() -> [(Coordinate, Coordinate?)] {
      while !step() {}
      let validDirections = validDirections.map { direction -> (Coordinate, Coordinate?) in
        let new = coordinate + direction
        guard new.character == "." else {
          return (new, directed ? new.characterDirection : direction)
        }
        return (coordinate, nil)
      }
      return validDirections
    }

    func step() -> Bool {
      for direction in validDirections {
        coordinate = coordinate + direction
        self.direction = direction
        visited.append(coordinate)
        steps += 1

        guard "><^v".contains(coordinate.character) else { return false }
        _ = step()
        return true
      }
      return true
    }
  }

  struct NodePair: Hashable {
    let source: Int
    let target: Int
  }

  func buildGraph(directed: Bool) -> (edges: [NodePair: Int], start: Node, end: Node) {
    var nodes: [Coordinate: Node] = [:]
    var edges: [NodePair: Int] = [:]

    let startNode = Node(id: Int.min, coordinate: Coordinate(x: 1, y: 0))
    let endNode = Node(id: Int.max, coordinate: Coordinate(x: map[0].count - 2, y: map.count - 1))

    nodes[startNode.coordinate] = startNode
    nodes[endNode.coordinate] = endNode

    var visited: Set<Coordinate> = []

    func addEdge(from source: Node, to target: Node, steps: Int) {
      edges[NodePair(source: source.id, target: target.id)] = steps
      source.adjacents.insert(target)
      if !directed {
        edges[NodePair(source: target.id, target: source.id)] = steps
        target.adjacents.insert(source)
      }
    }

    var queue: Deque<Walker> = [
      Walker(
        directed: directed,
        coordinate: Coordinate(x: 1, y: 1),
        direction: Coordinate(x: 0, y: 1),
        startNodeCoordinate: startNode.coordinate
      )
    ]
    while let walker = queue.popFirst() {
      let nextSteps = walker.walkUntilJunction()

      if nodes[walker.coordinate] == nil {
        nodes[walker.coordinate] = Node(coordinate: walker.coordinate)
      }

      addEdge(
        from: nodes[walker.startNodeCoordinate]!,
        to: nodes[walker.coordinate]!,
        steps: walker.steps
      )

      for (coordinate, direction) in nextSteps {
        guard let direction, coordinate + direction != walker.coordinate,
          !visited.contains(coordinate)
        else { continue }
        visited.insert(coordinate)
        addEdge(
          from: nodes[walker.startNodeCoordinate]!,
          to: nodes[walker.coordinate]!,
          steps: walker.steps
        )
        queue.append(
          Walker(
            directed: directed,
            coordinate: coordinate,
            direction: direction,
            startNodeCoordinate: walker.coordinate
          )
        )
      }
    }

    return (edges, startNode, endNode)
  }

  func dumpMap(nodes: [Coordinate: Node]) {
    print(
      map.enumerated()
        .map { y, line in
          line.enumerated()
            .map { x, item in
              if let node = nodes[Coordinate(x: x, y: y)] {
                String(node.id)
              } else {
                String(item == "#" ? "█" : item == "." ? " " : item)
              }
            }
            .joined()
        }
        .joined(separator: "\n")
    )
  }

  // MARK: - Data

  init(data: String) { map = data.mapLines { line in line.map { $0 } } }
}

nonisolated(unsafe) private var map: [[Character]] = []
nonisolated(unsafe) private var idIndex = 0
