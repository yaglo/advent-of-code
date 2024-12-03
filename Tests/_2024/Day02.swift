import Testing

@testable import AdventOfCode
@testable import _2024

@Test private func examplesDay02() throws {
  #expect(Day02(data: example).part1() == 2)
  #expect(Day02(data: example).part2() == 4)
}

@Test private func puzzleDay02() throws {
  #expect(Day02().part1() == 224)
  #expect(Day02().part2() == 293)
}

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
