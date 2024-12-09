import Testing

@testable import AdventOfCode
@testable import _2024

@Test("Day 9, Part 1 (Example)") private func day_09_example_part1() {
  #expect(Day09(data: example).part1() == 1928)
}

@Test("Day 9, Part 2 (Example)") private func day_09_example_part2() {
  #expect(Day09(data: example).part2() == 2858)
}

@Test("Day 9, Part 1") private func day_09_part1() {
  //  #expect(Day09().part1() == 336)
}

@Test("Day 9, Part 2") private func day_09_part2() {
  //  #expect(Day09().part2() == 1131)
}

private let example = "2333133121414131402"
