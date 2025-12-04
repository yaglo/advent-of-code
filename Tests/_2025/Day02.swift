import Testing

@testable import AdventOfCode
@testable import _2025

@Test("Day 2, Part 1 (Example)") private func day_02_example_part1() throws {
    #expect(Day02(data: example).part1() == 0)
}

@Test("Day 2, Part 2 (Example)") private func day_02_example_part2() throws {
    #expect(Day02(data: example).part2() == 0)
}

@Test("Day 2, Part 1") private func day_02_part1() throws { #expect(Day02().part1() == 0) }

@Test("Day 2, Part 2") private func day_02_part2() throws { #expect(Day02().part2() == 0) }

private let example = """
    """
