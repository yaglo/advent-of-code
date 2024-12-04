import Testing

@testable import AdventOfCode
@testable import _2024

@Test private func examplesDay04() throws {
  #expect(Day04(data: example).part1() == 18)
  #expect(Day04(data: example).part2() == 9)
}

@Test private func puzzleDay04() throws {
  #expect(Day04().part1() == 2567)
  #expect(Day04().part2() == 2029)
}

private let example = """
  MMMSXXMASM
  MSAMXMSMSA
  AMXSXMAAMM
  MSAMASMSMX
  XMASAMXAMM
  XXAMMXXAMA
  SMSMSASXSS
  SAXAMASAAA
  MAMMMXMMMM
  MXMXAXMASX
  """
