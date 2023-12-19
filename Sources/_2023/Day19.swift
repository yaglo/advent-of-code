// MARK: Day 19: Aplenty -

import AdventOfCode
import Foundation
import SE0270_RangeSet

struct Day19: AdventDay {
  // MARK: -

  func part1() -> Int {
    let inWorkflow = workflows["in"]!

    var accepted = [Int]()
    for (index, ratings) in partRatings.enumerated() {
      var instruction = inWorkflow
      instructions: while true {
        switch instruction {
        case let .match(rating, range, yes, no):
          if range.contains(ratings[rating]!) {
            instruction = yes
          } else {
            instruction = no
          }
        case let .workflow(name):
          instruction = workflows[name]!
        case .accept:
          accepted.append(index)
          break instructions
        case .reject:
          break instructions
        }
      }
    }

    return
      accepted
      .map { partRatings[$0].values.sum() }
      .sum()
  }

  func part2() async -> Int {
    struct AcceptedPath {
      var ratings: [String: Range<Int>]
      var workflows: Set<String>
    }

    func calculateAcceptedPaths(workflow: Instruction, acceptedPath: AcceptedPath) -> [AcceptedPath]
    {
      switch workflow {
      case .accept:
        return [acceptedPath]
      case .reject:
        return []
      case .match(let rating, let range, let yes, let no):
        var states = [AcceptedPath]()

        let complementRange =
          RangeSet(acceptedPath.ratings[rating]!)
          .subtracting(RangeSet(range))
          .ranges
          .first!

        let yesRatings = updating(rating, in: acceptedPath.ratings, with: range)
        let noRatings = updating(rating, in: acceptedPath.ratings, with: complementRange)

        states += calculateAcceptedPaths(
          workflow: yes, acceptedPath: .init(ratings: yesRatings, workflows: acceptedPath.workflows)
        )
        states += calculateAcceptedPaths(
          workflow: no, acceptedPath: .init(ratings: noRatings, workflows: acceptedPath.workflows)
        )
        return states
      case .workflow(let name):
        guard !acceptedPath.workflows.contains(name) else {
          return []
        }
        var newRange = acceptedPath
        newRange.workflows.insert(name)
        return calculateAcceptedPaths(workflow: workflows[name]!, acceptedPath: newRange)
      }
    }

    func updating(_ rating: String, in ratings: [String: Range<Int>], with range: Range<Int>)
      -> [String: Range<Int>]
    {
      var newRatings = ratings
      newRatings[rating] = ratings[rating]!.intersection(with: range)
      return newRatings
    }

    let acceptedPaths = calculateAcceptedPaths(
      workflow: workflows["in"]!,
      acceptedPath: AcceptedPath(
        ratings: ["x": fullRange, "m": fullRange, "a": fullRange, "s": fullRange],
        workflows: []
      )
    )

    return acceptedPaths.map {
      $0.ratings
        .values
        .product(of: \.count)
    }.sum()
  }

  // MARK: - Data

  enum Instruction {
    indirect case match(String, Range<Int>, Instruction, Instruction)
    case workflow(String)
    case accept
    case reject
  }

  let workflows: [String: Instruction]
  let partRatings: [[String: Int]]
  let fullRange = 1..<4001

  init(data: String) {
    let (workflowDefinitions, partRatings) = data.split(separator: "\n\n").splat()

    var workflows = [String: Instruction]()

    for definition in workflowDefinitions.lines() {
      let scanner = Scanner(string: String(definition))
      let name = scanner.scanCharacters(from: .letters)!
      _ = scanner.scanString("{")!
      let instruction = Day19.scanInstruction(scanner: scanner)
      _ = scanner.scanString("}")!
      workflows[name] = instruction
    }

    self.workflows = workflows

    self.partRatings = partRatings.lines().map { line in
      var ratings = [String: Int]()
      for pair in line.dropFirst().dropLast().split(separator: ",") {
        let (name, value) = pair.split(separator: "=").splat()
        ratings[String(name)] = Int(value)!
      }
      return ratings
    }

  }

  static func scanInstruction(scanner: Scanner) -> Instruction {
    let instruction = scanner.scanCharacters(from: .letters)!

    if "xmas".contains(instruction) {
      let rating = instruction
      let comparison = scanner.scanCharacter()!
      let value = scanner.scanInt()!
      let range =
        switch comparison {
        case "<": 1..<value
        case ">": value + 1..<4001
        default: fatalError()
        }
      _ = scanner.scanString(":")!
      let yes = scanInstruction(scanner: scanner)
      _ = scanner.scanString(",")!
      let no = scanInstruction(scanner: scanner)
      return .match(rating, range, yes, no)
    } else if "AR".contains(instruction) {
      return switch instruction {
      case "A": .accept
      case "R": .reject
      default: fatalError()
      }
    } else {
      return .workflow(instruction)
    }
  }
}
