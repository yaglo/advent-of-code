import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples() throws {
  #expect(Day09(data: example).part1() == 114)
  #expect(Day09(data: example).part2() == 2)
}

@Test private func puzzle() throws {
  #expect(Day09().part1() == 1_819_125_966)
  #expect(Day09().part2() == 1140)
}

private let example = """
  0 3 6 9 12 15
  1 3 6 10 15 21
  10 13 16 21 30 45
  """
