import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples_02() throws {
  #expect(Day02(data: example).part1() == 8)
  #expect(Day02(data: example).part2() == 2286)
}

//@Test private func puzzle_02() throws {
//  #expect(Day02().part1() == 2149)
//  #expect(Day02().part2() == 71274)
//}

private let example = """
  Game 1: 3 blue, 4 red; 1 red, 2 green, 6 blue; 2 green
  Game 2: 1 blue, 2 green; 3 green, 4 blue, 1 red; 1 green, 1 blue
  Game 3: 8 green, 6 blue, 20 red; 5 blue, 4 red, 13 green; 5 green, 1 red
  Game 4: 1 green, 3 red, 6 blue; 3 green, 6 red; 3 green, 15 blue, 14 red
  Game 5: 6 red, 1 blue, 3 green; 2 blue, 1 red, 2 green
  """
