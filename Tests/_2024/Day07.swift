import Testing

@testable import AdventOfCode
@testable import _2024

@Test("Day 7, Part 1 (Example)") private func day_07_example_part1() async throws {
  #expect(try await Day07(data: example).part1() == 3749)
}

@Test("Day 7, Part 2 (Example)") private func day_07_example_part2() async throws {
  #expect(try await Day07(data: example).part2() == 11387)
}

@Test("Day 7, Part 1") private func day_07_part1() async throws {
  #expect(try await Day07().part1() == 2_299_996_598_890)
}

@Test("Day 7, Part 2") private func day_07_part2() async throws {
  #expect(try await Day07().part2() == 362_646_859_298_554)
}

private let example = """
  190: 10 19
  3267: 81 40 27
  83: 17 5
  156: 15 6
  7290: 6 8 6 15
  161011: 16 10 13
  192: 17 8 14
  21037: 9 7 18 13
  292: 11 6 16 20
  """
