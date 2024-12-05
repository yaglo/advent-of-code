import Testing

@testable import AdventOfCode
@testable import _2024

@Test("Day 1, Part 1 (Example)") private func day_01_example_part1() throws {
  #expect(Day01(data: example).part1() == 11)
}

@Test("Day 1, Part 2 (Example)") private func day_01_example_part2() throws {
  #expect(Day01(data: example).part1() == 31)
}

@Test("Day 1, Part 1") private func day_01_part1() throws { #expect(Day01().part1() == 2_904_518) }

@Test("Day 1, Part 2") private func day_01_part2() throws { #expect(Day01().part2() == 18_650_129) }

private let example = """
  3   4
  4   3
  2   5
  1   3
  3   9
  3   3
  """
