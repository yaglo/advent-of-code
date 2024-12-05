import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples_03() throws {
  #expect(Day03(data: example).part1() == 4361)
  #expect(Day03(data: example).part2() == 467835)
}

//@Test private func puzzle_03() throws {
//  #expect(Day03().part1() == 520135)
//  #expect(Day03().part2() == 72_514_855)
//}

private let example = """
  467..114..
  ...*......
  ..35..633.
  ......#...
  617*......
  .....+.58.
  ..592.....
  ......755.
  ...$.*....
  .664.598..
  """
