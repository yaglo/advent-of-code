import Testing
@testable import AdventOfCode

@Test private func examples() throws {
  #expect(Day03(data: example).part1() == 4361)
  #expect(Day03(data: example).part2() == 467835)
}

@Test private func puzzle() throws {
  #expect(Day03().part1() == 520135)
  #expect(Day03().part2() == 72514855)
}

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
