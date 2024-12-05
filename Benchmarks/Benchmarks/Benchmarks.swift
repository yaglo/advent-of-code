import AdventOfCode
import ArgumentParser
import Benchmark
import _2024

@MainActor
let benchmarks = {
  for day in all2024Challenges {
    guard day.yearDay.1 == 5, day.yearDay.0 == 2024 else { continue }

        Benchmark("\(day.yearDay.1), \(day.yearDay.0), Part 1") { benchmark in
          for _ in benchmark.scaledIterations { _ = try await day.part1() }
        }

    Benchmark("December \(day.yearDay.1), \(day.yearDay.0), Part 2") { benchmark in
      for _ in benchmark.scaledIterations { _ = try await day.part2() }
    }
  }
}
