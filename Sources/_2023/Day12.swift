// MARK: Day 12: Hot Springs -

import AdventOfCode
import Algorithms

struct Day12: AdventDay {
  // MARK: -

  func part1() -> Int {
    puzzles.map { line, groups in
      var machine = CountingMachine(groups: groups)
      machine.processLine(line)
      return machine.acceptCount
    }
    .sum()
  }

  func part2() -> Int {
    puzzles.map { line, groups in
      let line = [line].cycled(times: 5).joined(separator: "?")
      let groups = [groups].cycled(times: 5).flatMap { $0 }

      var machine = CountingMachine(groups: groups)
      machine.processLine(line)
      return machine.acceptCount
    }
    .sum()
  }

  // MARK: - Data

  let puzzles: [(String, [Int])]

  init(data: String) {
    puzzles = data.mapLines { line in
      let parts = line.split(separator: " ")
      let puzzleLine = String(parts[0])
      let constraints = parts[1].split(separator: ",").compactMap { Int($0) }
      return (puzzleLine, constraints)
    }
  }

  // MARK: - Models

  struct CountingMachine {
    let states: [CountingState]
    let accept: CountingState

    init(groups: [Int]) {
      var states: [CountingState] = []

      var previous: CountingState? = nil

      func append(_ type: CountingState.StateType) {
        let state = CountingState(type: type, previous: previous)
        previous?.next = state
        states.append(state)
        previous = state
      }

      for group in groups {
        append(.first)
        for _ in 1..<group { append(.middle) }
        append(.last)
      }

      append(.accept)
      states.first?.count = 1
      self.states = states
      self.accept = states.last!
    }

    mutating func process(_ character: Character) {
      for state in states.reversed() where state.count > 0 {
        let counter = state.count
        state.invalidate()

        if character == "?" {
          state.transition(for: ".")?.count += counter
          state.transition(for: "#")?.count += counter
        } else {
          state.transition(for: character)?.count += counter
        }
      }
    }

    mutating func processLine(_ line: String) { for character in line { process(character) } }

    var acceptCount: Int { accept.count + accept.previous!.count }
  }

  class CountingState {
    let type: StateType
    weak var previous: CountingState?
    weak var next: CountingState?

    var count = 0

    init(type: StateType, previous: CountingState? = nil, next: CountingState? = nil) {
      self.type = type
      self.previous = previous
      self.next = next
    }

    enum StateType {
      case first
      case middle
      case last
      case accept
    }

    func transition(for character: Character) -> CountingState? {
      switch character {
      case "#":
        switch type {
        case .first, .middle: next
        case .last, .accept: nil
        }
      case ".":
        switch type {
        case .first, .accept: self
        case .middle: nil
        case .last: next
        }
      default: fatalError("Unknown character")
      }
    }

    func invalidate() { count = 0 }
  }
}
