import Testing

@testable import AdventOfCode
@testable import _2024

@Test func day04_example_part1() { #expect(Day04(data: example).part1() == 18) }
@Test func day04_example_part2() { #expect(Day04(data: example).part2() == 9) }

// @Test func day04_part1() { #expect(Day04().part1() == 2567) }
// @Test func day04_part2() { #expect(Day04().part2() == 2029) }

private let example = """
    MMMSXXMASM
    MSAMXMSMSA
    AMXSXMAAMM
    MSAMASMSMX
    XMASAMXAMM
    XXAMMXXAMA
    SMSMSASXSS
    SAXAMASAAA
    MAMMMXMMMM
    MXMXAXMASX
    """
