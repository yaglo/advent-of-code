import Testing
@testable import AdventOfCode

@Test private func examples() throws {
  #expect(Day07(data: example).part1() == 6440)
  #expect(Day07(data: example).part2() == 5905)
}

@Test private func puzzle() throws {
  #expect(Day07().part1() == 249204891)
  #expect(Day07().part2() == 249666369)
}

private let example = """
32T3K 765
T55J5 684
KK677 28
KTJJT 220
QQQJA 483
"""
