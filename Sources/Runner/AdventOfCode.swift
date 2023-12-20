import AdventOfCode
import ArgumentParser
import Foundation
import _2015
import _2022
import _2023

let allChallenges: [any AdventDay] = all2015Challenges + all2022Challenges + all2023Challenges

@main struct AdventOfCode: AsyncParsableCommand {
  @Argument(help: "The year of the challenge.") var year: Int?

  @Argument(help: "The day of the challenge. For December 1st, use '1'.") var day: Int?

  @Flag(help: "Benchmark the time taken by the solution") var benchmark: Bool = false

  @Flag(help: "Run all the days available") var all: Bool = false

  /// The selected day, or the latest day if no selection is provided.
  var selectedChallenge: any AdventDay {
    get throws {
      guard let year, let day else { return latestChallenge }
      guard let challenge = allChallenges.first(where: { $0.yearDay == (year, day) }) else {
        throw ValidationError("No solution found for year \(year), day \(day)")
      }
      return challenge
    }
  }

  /// The latest challenge in `allChallenges`.
  var latestChallenge: any AdventDay { allChallenges.max(by: { $0.yearDay < $1.yearDay })! }

  func run<T>(part: () async throws -> T, named: String) async -> Duration {
    var result: Result<T, Error>?
    let timing = await ContinuousClock()
      .measure { do { result = .success(try await part()) } catch { result = .failure(error) } }
    switch result! {
    case .success(let success): print("\(named): \(success)")
    case .failure(let failure as PartUnimplemented):
      print("Day \(failure.day) part \(failure.part) unimplemented")
    case .failure(let failure): print("\(named): Failed with error: \(failure)")
    }
    return timing
  }

  func run() async throws {
    let challenges = if all { allChallenges } else { try [selectedChallenge] }

    for challenge in challenges {
      print(
        "Executing Advent of Code challenge for December \(challenge.yearDay.1), \(challenge.yearDay.0)..."
      )

      let timing1 = await run(part: challenge.part1, named: "Part 1")
      let timing2 = await run(part: challenge.part2, named: "Part 2")

      if benchmark {
        print(
          "Part 1 took \(timing1.formatted(.units(allowed: [.microseconds, .milliseconds, .seconds, .nanoseconds], maximumUnitCount: 1))), part 2 took \(timing2.formatted(.units(allowed: [.microseconds, .milliseconds, .seconds], maximumUnitCount: 1)))."
        )
        #if DEBUG
          print("Looks like you're benchmarking debug code. Try swift run -c release")
        #endif
      }
    }
  }
}
