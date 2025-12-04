// MARK: Day 7: Bridge Repair -

import AdventOfCode
import math_h

@Day struct Day07 {
    // MARK: -

    func part1() async throws -> Int {
        try await solve(includeConcatenation: false)
    }

    func part2() async throws -> Int {
        try await solve(includeConcatenation: true)
    }

    private func solve(includeConcatenation: Bool) async throws -> Int {
        try await calibrations.parallelSum(chunkSize: 32) { (finalResult, operands) in
            func backtrack(_ index: Int, _ currentResult: Int) -> Bool {
                let powersOfTen = [
                    1, 10, 100, 1000, 10000, 100000, 1_000_000, 10_000_000, 100_000_000, 1_000_000_000,
                ]

                if index == operands.count - 1 {
                    return currentResult == finalResult
                }

                let rhsIndex = index + 1
                let nextOperand = operands[rhsIndex]

                if backtrack(rhsIndex, currentResult + nextOperand) {
                    return true
                }

                if backtrack(rhsIndex, currentResult * nextOperand) {
                    return true
                }

                if includeConcatenation {
                    let powerOfTen =
                        nextOperand < 10 ? powersOfTen[1] : powersOfTen[Int(log10(Double(nextOperand))) + 1]
                    let concatenated = currentResult * powerOfTen + nextOperand

                    if backtrack(rhsIndex, concatenated) {
                        return true
                    }
                }

                return false
            }
            return backtrack(0, operands[0]) ? finalResult : 0
        }
    }

    // MARK: - Data

    let calibrations: [(result: Int, operands: [Int])]

    init(data: String) {
        calibrations = data.lines().map { line in
            let (result, operands) = line.split(separator: ":").splat()
            return (Int(result)!, operands.integers(separatedBy: " "))
        }
    }
}
