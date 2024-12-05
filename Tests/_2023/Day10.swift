import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples_10() throws {
  #expect(Day10(data: example1).part1() == 4)
  #expect(Day10(data: example2).part1() == 8)
  #expect(Day10(data: example3).part2() == 4)
}

//@Test private func puzzle_10() throws {
//  #expect(Day10().part1() == 6923)
//  #expect(Day10().part2() == 529)
//}

private let example1 = """
  .....
  .S-7.
  .|.|.
  .L-J.
  .....
  """

private let example2 = """
  ..F7.
  .FJ|.
  SJ.L7
  |F--J
  LJ...
  """

private let example3 = """
  ...........
  .S-------7.
  .|F-----7|.
  .||.....||.
  .||.....||.
  .|L-7.F-J|.
  .|..|.|..|.
  .L--J.L--J.
  ...........
  """
