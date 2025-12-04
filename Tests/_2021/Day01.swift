import Testing

@testable import AdventOfCode
@testable import _2021

@Test func day01_example_part1() { #expect(Day01(data: example).part1() == 7) }
@Test func day01_example_part2() { #expect(Day01(data: example).part2() == 5) }

// @Test func day01_part1() { #expect(Day01().part1() == ???) }
// @Test func day01_part2() { #expect(Day01().part2() == ???) }

private let example = """
    199
    200
    208
    210
    200
    207
    240
    269
    260
    263
    """
