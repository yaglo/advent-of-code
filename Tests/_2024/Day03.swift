import Testing

@testable import AdventOfCode
@testable import _2024

@Test func day03_example_part1() { #expect(Day03(data: example1).part1() == 161) }
@Test func day03_example_part2() { #expect(Day03(data: example2).part2() == 48) }

// @Test func day03_part1() { #expect(Day03().part1() == 178_538_786) }
// @Test func day03_part2() { #expect(Day03().part2() == 102_467_299) }

private let example1 = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
private let example2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
