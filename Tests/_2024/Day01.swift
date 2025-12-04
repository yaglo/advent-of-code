import Testing

@testable import AdventOfCode
@testable import _2024

@Test func day01_example_part1() { #expect(Day01(data: example).part1() == 11) }
@Test func day01_example_part2() { #expect(Day01(data: example).part2() == 31) }

// @Test func day01_part1() { #expect(Day01().part1() == 2_904_518) }
// @Test func day01_part2() { #expect(Day01().part2() == 18_650_129) }

private let example = """
    3   4
    4   3
    2   5
    1   3
    3   9
    3   3
    """
