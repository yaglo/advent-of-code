import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examplesDay06() throws {
  #expect(Day06(data: example).part1() == 288)
  #expect(Day06(data: example).part2() == 71503)
}

//@Test private func puzzleDay06() throws {
//  #expect(Day06().part1() == 2_449_062)
//  #expect(Day06().part2() == 33_149_631)
//}

private let example = """
  Time:      7  15   30
  Distance:  9  40  200
  """
