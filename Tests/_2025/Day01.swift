import Testing

@testable import AdventOfCode
@testable import _2025

@Test func day01_example_part1() { #expect(Day01(data: example).part1() == 3) }
@Test func day01_example_part2() { #expect(Day01(data: example).part2() == 6) }

@Test func day01_part1() { #expect(Day01().part1() == 982) }
@Test func day01_part2() { #expect(Day01().part2() == 6106) }

private let example = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """
