import Testing
@testable import AdventOfCode

@Test private func examples() throws {
  #expect(Day06(data: example).part1() == 288)
  #expect(Day06(data: example).part2() == 71503)
}

@Test private func puzzle() throws {
  #expect(Day06().part1() == 2449062)
  #expect(Day06().part2() == 33149631)
}

private let example = """
Time:      7  15   30
Distance:  9  40  200
"""
