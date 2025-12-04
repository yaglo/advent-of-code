import Testing

@testable import AdventOfCode
@testable import _2023

@Test func day07_example_part1() { #expect(Day07(data: example).part1() == 6440) }
@Test func day07_example_part2() { #expect(Day07(data: example).part2() == 5905) }

// @Test func day07_part1() { #expect(Day07().part1() == 249_204_891) }
// @Test func day07_part2() { #expect(Day07().part2() == 249_666_369) }

private let example = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """
