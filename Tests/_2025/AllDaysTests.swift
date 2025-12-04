import Testing

@testable import AdventOfCode
@testable import _2025

// MARK: - Test Data

enum Day01Data {
  static let examplePart1Input = """
    L68
    L30
    R48
    L5
    R60
    L55
    L1
    L99
    R14
    L82
    """
  static let examplePart2Input = examplePart1Input
  static let examplePart1: Int? = 3
  static let examplePart2: Int? = 6
  static let answerPart1: Int? = 982
  static let answerPart2: Int? = 6106
}

// MARK: - Day 1

@Test("Day 1, Part 1 (Example)") func day01_ex1() {
  #expect(runPart(Day01(data: Day01Data.examplePart1Input).part1) == Day01Data.examplePart1)
}
@Test("Day 1, Part 2 (Example)") func day01_ex2() {
  #expect(runPart(Day01(data: Day01Data.examplePart2Input).part2) == Day01Data.examplePart2)
}
@Test("Day 1, Part 1") func day01_p1() { #expect(runPart(Day01().part1) == Day01Data.answerPart1) }
@Test("Day 1, Part 2") func day01_p2() { #expect(runPart(Day01().part2) == Day01Data.answerPart2) }

// MARK: - Day 2

@Test("Day 2, Part 1 (Example)") func day02_ex1() {
  #expect(runPart(Day02(data: "").part1) == nil as Int?)
}
@Test("Day 2, Part 2 (Example)") func day02_ex2() {
  #expect(runPart(Day02(data: "").part2) == nil as Int?)
}
@Test("Day 2, Part 1") func day02_p1() { #expect(runPart(Day02().part1) == nil as Int?) }
@Test("Day 2, Part 2") func day02_p2() { #expect(runPart(Day02().part2) == nil as Int?) }

// MARK: - Day 3

@Test("Day 3, Part 1 (Example)") func day03_ex1() {
  #expect(runPart(Day03(data: "").part1) == nil as Int?)
}
@Test("Day 3, Part 2 (Example)") func day03_ex2() {
  #expect(runPart(Day03(data: "").part2) == nil as Int?)
}
@Test("Day 3, Part 1") func day03_p1() { #expect(runPart(Day03().part1) == nil as Int?) }
@Test("Day 3, Part 2") func day03_p2() { #expect(runPart(Day03().part2) == nil as Int?) }

// MARK: - Day 4

@Test("Day 4, Part 1 (Example)") func day04_ex1() {
  #expect(runPart(Day04(data: "").part1) == nil as Int?)
}
@Test("Day 4, Part 2 (Example)") func day04_ex2() {
  #expect(runPart(Day04(data: "").part2) == nil as Int?)
}
@Test("Day 4, Part 1") func day04_p1() { #expect(runPart(Day04().part1) == nil as Int?) }
@Test("Day 4, Part 2") func day04_p2() { #expect(runPart(Day04().part2) == nil as Int?) }

// MARK: - Day 5

@Test("Day 5, Part 1 (Example)") func day05_ex1() {
  #expect(runPart(Day05(data: "").part1) == nil as Int?)
}
@Test("Day 5, Part 2 (Example)") func day05_ex2() {
  #expect(runPart(Day05(data: "").part2) == nil as Int?)
}
@Test("Day 5, Part 1") func day05_p1() { #expect(runPart(Day05().part1) == nil as Int?) }
@Test("Day 5, Part 2") func day05_p2() { #expect(runPart(Day05().part2) == nil as Int?) }

// MARK: - Day 6

@Test("Day 6, Part 1 (Example)") func day06_ex1() {
  #expect(runPart(Day06(data: "").part1) == nil as Int?)
}
@Test("Day 6, Part 2 (Example)") func day06_ex2() {
  #expect(runPart(Day06(data: "").part2) == nil as Int?)
}
@Test("Day 6, Part 1") func day06_p1() { #expect(runPart(Day06().part1) == nil as Int?) }
@Test("Day 6, Part 2") func day06_p2() { #expect(runPart(Day06().part2) == nil as Int?) }

// MARK: - Day 7

@Test("Day 7, Part 1 (Example)") func day07_ex1() {
  #expect(runPart(Day07(data: "").part1) == nil as Int?)
}
@Test("Day 7, Part 2 (Example)") func day07_ex2() {
  #expect(runPart(Day07(data: "").part2) == nil as Int?)
}
@Test("Day 7, Part 1") func day07_p1() { #expect(runPart(Day07().part1) == nil as Int?) }
@Test("Day 7, Part 2") func day07_p2() { #expect(runPart(Day07().part2) == nil as Int?) }

// MARK: - Day 8

@Test("Day 8, Part 1 (Example)") func day08_ex1() {
  #expect(runPart(Day08(data: "").part1) == nil as Int?)
}
@Test("Day 8, Part 2 (Example)") func day08_ex2() {
  #expect(runPart(Day08(data: "").part2) == nil as Int?)
}
@Test("Day 8, Part 1") func day08_p1() { #expect(runPart(Day08().part1) == nil as Int?) }
@Test("Day 8, Part 2") func day08_p2() { #expect(runPart(Day08().part2) == nil as Int?) }

// MARK: - Day 9

@Test("Day 9, Part 1 (Example)") func day09_ex1() {
  #expect(runPart(Day09(data: "").part1) == nil as Int?)
}
@Test("Day 9, Part 2 (Example)") func day09_ex2() {
  #expect(runPart(Day09(data: "").part2) == nil as Int?)
}
@Test("Day 9, Part 1") func day09_p1() { #expect(runPart(Day09().part1) == nil as Int?) }
@Test("Day 9, Part 2") func day09_p2() { #expect(runPart(Day09().part2) == nil as Int?) }

// MARK: - Day 10

@Test("Day 10, Part 1 (Example)") func day10_ex1() {
  #expect(runPart(Day10(data: "").part1) == nil as Int?)
}
@Test("Day 10, Part 2 (Example)") func day10_ex2() {
  #expect(runPart(Day10(data: "").part2) == nil as Int?)
}
@Test("Day 10, Part 1") func day10_p1() { #expect(runPart(Day10().part1) == nil as Int?) }
@Test("Day 10, Part 2") func day10_p2() { #expect(runPart(Day10().part2) == nil as Int?) }

// MARK: - Day 11

@Test("Day 11, Part 1 (Example)") func day11_ex1() {
  #expect(runPart(Day11(data: "").part1) == nil as Int?)
}
@Test("Day 11, Part 2 (Example)") func day11_ex2() {
  #expect(runPart(Day11(data: "").part2) == nil as Int?)
}
@Test("Day 11, Part 1") func day11_p1() { #expect(runPart(Day11().part1) == nil as Int?) }
@Test("Day 11, Part 2") func day11_p2() { #expect(runPart(Day11().part2) == nil as Int?) }

// MARK: - Day 12

@Test("Day 12, Part 1 (Example)") func day12_ex1() {
  #expect(runPart(Day12(data: "").part1) == nil as Int?)
}
@Test("Day 12, Part 2 (Example)") func day12_ex2() {
  #expect(runPart(Day12(data: "").part2) == nil as Int?)
}
@Test("Day 12, Part 1") func day12_p1() { #expect(runPart(Day12().part1) == nil as Int?) }
@Test("Day 12, Part 2") func day12_p2() { #expect(runPart(Day12().part2) == nil as Int?) }
