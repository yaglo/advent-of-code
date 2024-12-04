// MARK: Day 3: Mull It Over -

import AdventOfCode

struct Day03: AdventDay {
  // MARK: -

  func part1() -> Int {
    data
      .lines()
      .sum { line in
        line.matches(of: /mul\((\d+),(\d+)\)/).sum { match in
          Int(match.output.1)! * Int(match.output.2)!
        }
      }
  }

  func part2() -> Int {
    data
      .lines()
      .reduce((sum: 0, isActive: true)) { acc, line in
        line
          .matches(of: /mul\((\d+),(\d+)\)|do\(\)|don\'t\(\)/)
          .reduce(acc) { acc, match in
            switch match.output {
            case ("do()", _, _):
              (acc.sum, true)
            case ("don't()", _, _):
              (acc.sum, false)
            case let (_, x?, y?):
              (acc.isActive ? acc.sum + (Int(x)! * Int(y)!) : acc.sum, acc.isActive)
            default:
              fatalError()
            }
          }
      }
      .sum
  }

  // MARK: - Data

  let data: String
}
