import Testing

@testable import AdventOfCode
@testable import _2024

@Test("Day 2, Part 1 (Example)") private func day_02_example_part1() throws {
  #expect(Day02(data: example).part1() == 2)
}

@Test("Day 2, Part 2 (Example)") private func day_02_example_part2() throws {
  #expect(Day02(data: example).part2() == 4)
}

@Test("Day 2, Part 1") private func day_02_part1() throws { #expect(Day02().part1() == 224) }

@Test("Day 2, Part 2") private func day_02_part2() throws { #expect(Day02().part2() == 293) }

private let example = """
  7 6 4 2 1
  1 2 7 8 9
  9 7 6 2 1
  1 3 2 4 5
  8 6 4 4 1
  1 3 6 7 9
  6 5 4 6 7
  1 2 3 3 2
  3 2 1 3 3
  """
