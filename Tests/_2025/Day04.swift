import Testing

@testable import AdventOfCode
@testable import _2025

@Test func day04_example_part1() { #expect(Day04(data: example).part1() == 13) }
@Test func day04_example_part2() { #expect(Day04(data: example).part2() == 43) }

@Test func day04_part1() { #expect(Day04().part1() == 1549) }
@Test func day04_part2() { #expect(Day04().part2() == 8887) }

// swiftlint:disable:next line_length
private let example = """
    ..@@.@@@@.
    @@@.@.@.@@
    @@@@@.@.@@
    @.@@@@..@.
    @@.@@@@.@@
    .@@@@@@@.@
    .@.@.@.@@@
    @.@@@.@@@@
    .@@@@@@@@.
    @.@.@@@.@.
    """
