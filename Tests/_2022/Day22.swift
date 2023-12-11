import Testing

@testable import AdventOfCode
@testable import _2022

@Test private func examples() throws {
  #expect(Day22(data: example).part1() == 6032)
  #expect(Day22(data: example).part2() == 0)
}

//@Test private func puzzle() throws {
//  #expect(Day22().part1() == 0)
//  #expect(Day22().part2() == 0)
//}

private let example = """
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """
