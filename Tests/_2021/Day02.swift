import Testing

@testable import AdventOfCode
@testable import _2021

@Test func day02_example_part1() { #expect(Day02(data: example).part1() == 150) }
@Test func day02_example_part2() { #expect(Day02(data: example).part2() == 900) }

// @Test func day02_part1() { #expect(Day02().part1() == ???) }
// @Test func day02_part2() { #expect(Day02().part2() == ???) }

private let example = """
    forward 5
    down 5
    forward 8
    up 3
    down 8
    forward 2
    """
