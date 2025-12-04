import Testing

@testable import AdventOfCode
@testable import _2024

@Test func day09_example_part1() { #expect(Day09(data: example).part1() == 1928) }
@Test func day09_example_part2() { #expect(Day09(data: example).part2() == 2858) }

// @Test func day09_part1() { #expect(Day09().part1() == ???) }
// @Test func day09_part2() { #expect(Day09().part2() == ???) }

private let example = "2333133121414131402"
