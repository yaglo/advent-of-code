import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples_08() throws {
  #expect(Day08(data: example1).part1() == 6)
  #expect(Day08(data: example2).part2() == 6)
}

//@Test private func puzzle_08() throws {
//  #expect(Day08().part1() == 16343)
//  #expect(Day08().part2() == 15_299_095_336_639)
//}

private let example1 = """
  LLR

  AAA = (BBB, BBB)
  BBB = (AAA, ZZZ)
  ZZZ = (ZZZ, ZZZ)
  """

private let example2 = """
  LR

  11A = (11B, XXX)
  11B = (XXX, 11Z)
  11Z = (11B, XXX)
  22A = (22B, XXX)
  22B = (22C, 22C)
  22C = (22Z, 22Z)
  22Z = (22B, 22B)
  XXX = (XXX, XXX)
  """
