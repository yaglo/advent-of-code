import Testing

@testable import AdventOfCode
@testable import _2025

@Test func day06_example_part1() { #expect(Day06(data: example).part1() == 4_277_556) }
@Test func day06_example_part2() { #expect(Day06(data: example).part2() == 3_263_827) }

@Test func day06_part1() { #expect(Day06().part1() == 6_417_439_773_370) }
@Test func day06_part2() { #expect(Day06().part2() == 11_044_319_475_191) }

private let example = [
    "123 328  51 64 ",
    " 45 64  387 23 ",
    "  6 98  215 314",
    "*   +   *   +  ",
].joined(separator: "\n")
