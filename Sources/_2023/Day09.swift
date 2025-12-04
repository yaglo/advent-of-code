// MARK: Day 9: Mirage Maintenance -

import AdventOfCode
import Algorithms

@Day struct Day09 {
    // MARK: -

    func part1() -> Int { sequences.sum(applying: extrapolateNextElement(in:)) }

    func part2() -> Int {
        sequences.sum { sequence in extrapolateNextElement(in: sequence.reversed()) }
    }

    // MARK: - Helpers

    func extrapolateNextElement(in sequence: [Int]) -> Int {
        var lastElements = [sequence.last!]

        var diffs = sequence
        while diffs.contains(where: { $0 != 0 }) {
            diffs = zip(diffs.dropFirst(), diffs).map(-)
            lastElements.append(diffs.last!)
        }

        return lastElements.sum()
    }

    // MARK: - Data

    let sequences: [[Int]]

    init(data: String) { sequences = data.mapLines { $0.integers(separatedBy: " ") } }
}
