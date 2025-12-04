import Testing

@testable import AdventOfCode
@testable import _2023

@Test func day14_example_part1() { #expect(Day14(data: example).part1() == 136) }
@Test func day14_example_part2() { #expect(Day14(data: example).part2() == 64) }

// @Test func day14_part1() { #expect(Day14().part1() == 113486) }
// @Test func day14_part2() { #expect(Day14().part2() == 104409) }

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
