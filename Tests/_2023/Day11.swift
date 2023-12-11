import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples() throws {
  #expect(Day11(data: example).part1() == 374)
}

@Test private func puzzle() throws {
  #expect(Day11().part1() == 9329143)
  #expect(Day11().part2() == 710674907809)
}

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
