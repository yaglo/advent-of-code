import Testing

@testable import AdventOfCode
@testable import _2015

@Test func day03_examples() {
    #expect(Day03(data: ">").part1() == 2)
    #expect(Day03(data: "^>v<").part1() == 4)
    #expect(Day03(data: "^v^v^v^v^v").part1() == 2)
    #expect(Day03(data: "^v").part2() == 3)
    #expect(Day03(data: "^>v<").part2() == 3)
    #expect(Day03(data: "^v^v^v^v^v").part2() == 11)
}

// @Test func day03_part1() { #expect(Day03().part1() == 2081) }
// @Test func day03_part2() { #expect(Day03().part2() == 2341) }
