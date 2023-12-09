import Foundation

struct Day06: AdventDay {
  // MARK: -

  func part1() -> Int {
    zip(times, records)
      .map { numberOfWinningOptions(totalTime: Double($0)!, recordDistance: Double($1)!) }
      .product()
  }

  func part2() -> Int {
    numberOfWinningOptions(
      totalTime: Double(times.joined())!,
      recordDistance: Double(records.joined())!
    )
  }

  func numberOfWinningOptions(totalTime t: Double, recordDistance r: Double) -> Int {
    let d = (t * t - 4 * r).squareRoot()
    let minHold = ceil((t - d) / 2)
    let maxHold = floor((t + d) / 2)
    return Int(maxHold - minHold) + (d.isWhole ? -1 : 1)
  }

  // MARK: - Data

  let times: [String]
  let records: [String]

  init(data: String) {
    let lines = data.mapLines { line in
      line
        .split(separator: " ")
        .dropFirst()
        .map(String.init)
    }
    times = lines.first!
    records = lines.dropFirst().first!
  }
}
