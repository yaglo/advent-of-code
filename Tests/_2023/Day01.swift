import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examplesDay01() throws {
  #expect(Day01(data: example1).part1() == 142)
  #expect(Day01(data: example2).part2() == 281)
}

//@Test private func puzzleDay01() throws {
//  #expect(Day01().part1() == 54644)
//  #expect(Day01().part2() == 53348)
//}

private let example1 = """
  1abc2
  pqr3stu8vwx
  a1b2c3d4e5f
  treb7uchet
  """

private let example2 = """
  two1nine
  eightwothree
  abcone2threexyz
  xtwone3four
  4nineeightseven2
  zoneight234
  7pqrstsixteen
  """
