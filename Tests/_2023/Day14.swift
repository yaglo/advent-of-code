import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples() throws {
  #expect(Day14(data: example).part1() == 136)
  #expect(Day14(data: example).part2() == 64)
}

@Test private func puzzle() throws {
  #expect(Day14().part1() == 113486)
  #expect(Day14().part2() == 104409)
}

private let example = """
  O....#....
  O.OO#....#
  .....##...
  OO.#O....O
  .O.....O#.
  O.#..O.#.#
  ..O..#O..O
  .......O..
  #....###..
  #OO..#....
  """
