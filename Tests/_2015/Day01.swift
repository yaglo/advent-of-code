import Testing

@testable import AdventOfCode
@testable import _2015

@Test func day01_examples() {
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

// @Test func day01_part1() { #expect(Day01().part1() == 74) }
// @Test func day01_part2() { #expect(Day01().part2() == 1795) }
