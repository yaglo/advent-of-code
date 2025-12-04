import Testing

@testable import AdventOfCode
@testable import _2023

@Test func day09_example_part1() { #expect(Day09(data: example).part1() == 114) }
@Test func day09_example_part2() { #expect(Day09(data: example).part2() == 2) }

// @Test func day09_part1() { #expect(Day09().part1() == 1_819_125_966) }
// @Test func day09_part2() { #expect(Day09().part2() == 1140) }

private let example = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """
