import Testing

@testable import AdventOfCode
@testable import _2025

@Test func day03_example_part1() { #expect(Day03(data: example).part1() == 357) }
@Test func day03_example_part2() { #expect(Day03(data: example).part2() == 3_121_910_778_619) }

@Test func day03_part1() { #expect(Day03().part1() == 17324) }
@Test func day03_part2() { #expect(Day03().part2() == 171_846_613_143_331) }

private let example = """
    987654321111111
    811111111111119
    234234234234278
    818181911112111
    """
