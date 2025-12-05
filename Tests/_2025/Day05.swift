import Testing

@testable import AdventOfCode
@testable import _2025

@Test func day05_example_part1() { #expect(Day05(data: example).part1() == 3) }
@Test func day05_example_part2() { #expect(Day05(data: example).part2() == 14) }

@Test func day05_part1() { #expect(Day05().part1() == 744) }
@Test func day05_part2() { #expect(Day05().part2() == 347_468_726_696_961) }

private let example = """
    3-5
    10-14
    16-20
    12-18

    1
    5
    8
    11
    17
    32
    """
