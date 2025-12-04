import Testing

@testable import AdventOfCode
@testable import _2024

@Test func day05_example_part1() { #expect(Day05(data: example).part1() == 143) }
@Test func day05_example_part2() { #expect(Day05(data: example).part2() == 123) }

// @Test func day05_part1() { #expect(Day05().part1() == 5166) }
// @Test func day05_part2() { #expect(Day05().part2() == 4679) }

private let example = """
    47|53
    97|13
    97|61
    97|47
    75|29
    61|13
    75|53
    29|13
    97|29
    53|29
    61|53
    97|53
    61|29
    47|13
    75|47
    97|75
    47|61
    75|61
    47|29
    75|13
    53|13

    75,47,61,53,29
    97,61,53,29,13
    75,29,13
    75,97,47,61,53
    61,13,29
    97,13,75,29,47
    """
