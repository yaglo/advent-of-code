import Testing

@testable import AdventOfCode
@testable import _2023

@Test func day03_example_part1() { #expect(Day03(data: example).part1() == 4361) }
@Test func day03_example_part2() { #expect(Day03(data: example).part2() == 467835) }

// @Test func day03_part1() { #expect(Day03().part1() == 520135) }
// @Test func day03_part2() { #expect(Day03().part2() == 72_514_855) }

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
