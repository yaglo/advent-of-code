import Foundation

struct Day6: Day {
    let times: [String]
    let records: [String]

    func part1() -> Int {
        zip(times, records)
            .map { numberOfWinningOptions(totalTime: Double($0)!, recordDistance: Double($1)!) }
            .product()
    }

    func part2() -> Int {
        numberOfWinningOptions(totalTime: Double(times.joined())!, recordDistance: Double(records.joined())!)
    }

    func numberOfWinningOptions(totalTime t: Double, recordDistance r: Double) -> Int {
        let d = (t * t - 4 * r).squareRoot()
        let minHold = ceil((t - d) / 2)
        let maxHold = floor((t + d) / 2)
        return Int(maxHold - minHold) + 1
    }

    init(_ input: String) {
        let lines = input.split(whereSeparator: \.isNewline).map { line in
            line
                .split(separator: " ")
                .dropFirst()
                .map { String($0) }
        }
        times = lines[0]
        records = lines[1]
    }
}
