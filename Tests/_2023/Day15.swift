import Testing

@testable import AdventOfCode
@testable import _2023

@Test func day15_example_part1() { #expect(Day15(data: example).part1() == 1320) }
@Test func day15_example_part2() { #expect(Day15(data: example).part2() == 145) }

// @Test func day15_part1() { #expect(Day15().part1() == 517551) }
// @Test func day15_part2() { #expect(Day15().part2() == 286097) }

private let example = "rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7"
