import Testing

@testable import AdventOfCode
@testable import _2025

@Test func day02_example_part1() { #expect(Day02(data: example).part1() == 1_227_775_554) }
// @Test func day02_example_part2() { #expect(Day02(data: example).part2() == ???) }

// @Test func day02_part1() { #expect(Day02().part1() == ???) }
// @Test func day02_part2() { #expect(Day02().part2() == ???) }

// swiftlint:disable:next line_length
private let example =
    "11-22,95-115,998-1012,1188511880-1188511890,222220-222224,1698522-1698528,446443-446449,38593856-38593862,565653-565659,824824821-824824827,2121212118-2121212124"
