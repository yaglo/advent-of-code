import AdventOfCode
import Benchmark
import Foundation
import _2023
import _2025

let benchmarks: @Sendable () -> Void = {
    Benchmark.defaultConfiguration = .init(
        metrics: .extended,
        timeUnits: .microseconds
    )

    for day in all2025Challenges { registerBenchmark(for: day) }
    registerBenchmark(for: all2023Challenges[13])  // Day14
}

func registerBenchmark<T: AdventDay>(for day: T) {
    let (year, dayNum) = day.yearDay
    let dayPadded = dayNum < 10 ? "0\(dayNum)" : "\(dayNum)"

    Benchmark("\(year)_day\(dayPadded)_part1") { benchmark in
        let instance = T(data: T.loadData())
        for _ in benchmark.scaledIterations { _ = try await instance.part1() }
    }

    Benchmark("\(year)_day\(dayPadded)_part2") { benchmark in
        let instance = T(data: T.loadData())
        for _ in benchmark.scaledIterations { _ = try await instance.part2() }
    }
}
