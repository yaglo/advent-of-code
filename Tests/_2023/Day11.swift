import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples_11() throws { #expect(Day11(data: example).part1() == 374) }

//@Test private func puzzle_11() throws {
//  #expect(Day11().part1() == 9_329_143)
//  #expect(Day11().part2() == 710_674_907_809)
//}

private let example = """
  ...#......
  .......#..
  #.........
  ..........
  ......#...
  .#........
  .........#
  ..........
  .......#..
  #...#.....
  """
