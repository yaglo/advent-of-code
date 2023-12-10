import Testing

@testable import AdventOfCode
@testable import _2015

@Test private func examples() throws {
  #expect(Day01(data: "(())").part1() == 0)
  #expect(Day01(data: "()()").part1() == 0)
  #expect(Day01(data: "(((").part1() == 3)
  #expect(Day01(data: "(()(()(").part1() == 3)
  #expect(Day01(data: "))(((((").part1() == 3)
  #expect(Day01(data: "())").part1() == -1)
  #expect(Day01(data: "))(").part1() == -1)
  #expect(Day01(data: ")))").part1() == -3)
  #expect(Day01(data: ")())())").part1() == -3)
  #expect(Day01(data: ")").part2() == 1)
  #expect(Day01(data: "()())").part2() == 5)
}

@Test private func puzzle() throws {
  #expect(Day01().part1() == 74)
  #expect(Day01().part2() == 1795)
}
