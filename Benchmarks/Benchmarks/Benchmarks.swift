import AdventOfCode
import ArgumentParser
import Benchmark
import _2023

let benchmarks = {
  for day in all2023Challenges {
    Benchmark("\(day.yearDay.1), \(day.yearDay.0), Part 1") { benchmark in
      for _ in benchmark.scaledIterations {
        _ = try await day.part1()
      }
    }

    Benchmark("December \(day.yearDay.1), \(day.yearDay.0), Part 2") { benchmark in
      for _ in benchmark.scaledIterations {
        _ = try await day.part2()
      }
    }
  }
}
