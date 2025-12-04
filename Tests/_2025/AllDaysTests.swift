import Testing

@testable import AdventOfCode
@testable import _2025

// MARK: - Day 1
@Test("Day 1, Part 1 (Example)") func day01_ex1() {
    #expect(runPart(Day01(data: Day01.examplePart1Input).part1) == Day01.examplePart1)
}
@Test("Day 1, Part 2 (Example)") func day01_ex2() {
    #expect(runPart(Day01(data: Day01.examplePart2Input).part2) == Day01.examplePart2)
}
@Test("Day 1, Part 1") func day01_p1() { #expect(runPart(Day01().part1) == Day01.answerPart1) }
@Test("Day 1, Part 2") func day01_p2() { #expect(runPart(Day01().part2) == Day01.answerPart2) }

// MARK: - Day 2
@Test("Day 2, Part 1 (Example)") func day02_ex1() {
    #expect(runPart(Day02(data: Day02.examplePart1Input).part1) == Day02.examplePart1)
}
@Test("Day 2, Part 2 (Example)") func day02_ex2() {
    #expect(runPart(Day02(data: Day02.examplePart2Input).part2) == Day02.examplePart2)
}
@Test("Day 2, Part 1") func day02_p1() { #expect(runPart(Day02().part1) == Day02.answerPart1) }
@Test("Day 2, Part 2") func day02_p2() { #expect(runPart(Day02().part2) == Day02.answerPart2) }

// MARK: - Day 3
@Test("Day 3, Part 1 (Example)") func day03_ex1() {
    #expect(runPart(Day03(data: Day03.examplePart1Input).part1) == Day03.examplePart1)
}
@Test("Day 3, Part 2 (Example)") func day03_ex2() {
    #expect(runPart(Day03(data: Day03.examplePart2Input).part2) == Day03.examplePart2)
}
@Test("Day 3, Part 1") func day03_p1() { #expect(runPart(Day03().part1) == Day03.answerPart1) }
@Test("Day 3, Part 2") func day03_p2() { #expect(runPart(Day03().part2) == Day03.answerPart2) }

// MARK: - Day 4
@Test("Day 4, Part 1 (Example)") func day04_ex1() {
    #expect(runPart(Day04(data: Day04.examplePart1Input).part1) == Day04.examplePart1)
}
@Test("Day 4, Part 2 (Example)") func day04_ex2() {
    #expect(runPart(Day04(data: Day04.examplePart2Input).part2) == Day04.examplePart2)
}
@Test("Day 4, Part 1") func day04_p1() { #expect(runPart(Day04().part1) == Day04.answerPart1) }
@Test("Day 4, Part 2") func day04_p2() { #expect(runPart(Day04().part2) == Day04.answerPart2) }

// MARK: - Day 5
@Test("Day 5, Part 1 (Example)") func day05_ex1() {
    #expect(runPart(Day05(data: Day05.examplePart1Input).part1) == Day05.examplePart1)
}
@Test("Day 5, Part 2 (Example)") func day05_ex2() {
    #expect(runPart(Day05(data: Day05.examplePart2Input).part2) == Day05.examplePart2)
}
@Test("Day 5, Part 1") func day05_p1() { #expect(runPart(Day05().part1) == Day05.answerPart1) }
@Test("Day 5, Part 2") func day05_p2() { #expect(runPart(Day05().part2) == Day05.answerPart2) }

// MARK: - Day 6
@Test("Day 6, Part 1 (Example)") func day06_ex1() {
    #expect(runPart(Day06(data: Day06.examplePart1Input).part1) == Day06.examplePart1)
}
@Test("Day 6, Part 2 (Example)") func day06_ex2() {
    #expect(runPart(Day06(data: Day06.examplePart2Input).part2) == Day06.examplePart2)
}
@Test("Day 6, Part 1") func day06_p1() { #expect(runPart(Day06().part1) == Day06.answerPart1) }
@Test("Day 6, Part 2") func day06_p2() { #expect(runPart(Day06().part2) == Day06.answerPart2) }

// MARK: - Day 7
@Test("Day 7, Part 1 (Example)") func day07_ex1() {
    #expect(runPart(Day07(data: Day07.examplePart1Input).part1) == Day07.examplePart1)
}
@Test("Day 7, Part 2 (Example)") func day07_ex2() {
    #expect(runPart(Day07(data: Day07.examplePart2Input).part2) == Day07.examplePart2)
}
@Test("Day 7, Part 1") func day07_p1() { #expect(runPart(Day07().part1) == Day07.answerPart1) }
@Test("Day 7, Part 2") func day07_p2() { #expect(runPart(Day07().part2) == Day07.answerPart2) }

// MARK: - Day 8
@Test("Day 8, Part 1 (Example)") func day08_ex1() {
    #expect(runPart(Day08(data: Day08.examplePart1Input).part1) == Day08.examplePart1)
}
@Test("Day 8, Part 2 (Example)") func day08_ex2() {
    #expect(runPart(Day08(data: Day08.examplePart2Input).part2) == Day08.examplePart2)
}
@Test("Day 8, Part 1") func day08_p1() { #expect(runPart(Day08().part1) == Day08.answerPart1) }
@Test("Day 8, Part 2") func day08_p2() { #expect(runPart(Day08().part2) == Day08.answerPart2) }

// MARK: - Day 9
@Test("Day 9, Part 1 (Example)") func day09_ex1() {
    #expect(runPart(Day09(data: Day09.examplePart1Input).part1) == Day09.examplePart1)
}
@Test("Day 9, Part 2 (Example)") func day09_ex2() {
    #expect(runPart(Day09(data: Day09.examplePart2Input).part2) == Day09.examplePart2)
}
@Test("Day 9, Part 1") func day09_p1() { #expect(runPart(Day09().part1) == Day09.answerPart1) }
@Test("Day 9, Part 2") func day09_p2() { #expect(runPart(Day09().part2) == Day09.answerPart2) }

// MARK: - Day 10
@Test("Day 10, Part 1 (Example)") func day10_ex1() {
    #expect(runPart(Day10(data: Day10.examplePart1Input).part1) == Day10.examplePart1)
}
@Test("Day 10, Part 2 (Example)") func day10_ex2() {
    #expect(runPart(Day10(data: Day10.examplePart2Input).part2) == Day10.examplePart2)
}
@Test("Day 10, Part 1") func day10_p1() { #expect(runPart(Day10().part1) == Day10.answerPart1) }
@Test("Day 10, Part 2") func day10_p2() { #expect(runPart(Day10().part2) == Day10.answerPart2) }

// MARK: - Day 11
@Test("Day 11, Part 1 (Example)") func day11_ex1() {
    #expect(runPart(Day11(data: Day11.examplePart1Input).part1) == Day11.examplePart1)
}
@Test("Day 11, Part 2 (Example)") func day11_ex2() {
    #expect(runPart(Day11(data: Day11.examplePart2Input).part2) == Day11.examplePart2)
}
@Test("Day 11, Part 1") func day11_p1() { #expect(runPart(Day11().part1) == Day11.answerPart1) }
@Test("Day 11, Part 2") func day11_p2() { #expect(runPart(Day11().part2) == Day11.answerPart2) }

// MARK: - Day 12
@Test("Day 12, Part 1 (Example)") func day12_ex1() {
    #expect(runPart(Day12(data: Day12.examplePart1Input).part1) == Day12.examplePart1)
}
@Test("Day 12, Part 2 (Example)") func day12_ex2() {
    #expect(runPart(Day12(data: Day12.examplePart2Input).part2) == Day12.examplePart2)
}
@Test("Day 12, Part 1") func day12_p1() { #expect(runPart(Day12().part1) == Day12.answerPart1) }
@Test("Day 12, Part 2") func day12_p2() { #expect(runPart(Day12().part2) == Day12.answerPart2) }
