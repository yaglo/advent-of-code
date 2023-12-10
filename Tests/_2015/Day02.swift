import Testing

@testable import AdventOfCode
@testable import _2015

@Test private func examples() throws {
  #expect(Day02(data: "2x3x4").part1() == 58)
  #expect(Day02(data: "1x1x10").part1() == 43)
  #expect(Day02(data: "2x3x4").part2() == 34)
  #expect(Day02(data: "1x1x10").part2() == 14)
}

@Test private func puzzle() throws {
  #expect(Day02().part1() == 1_586_300)
  #expect(Day02().part2() == 3_737_498)
}
