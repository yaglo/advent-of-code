import Testing

@testable import AdventOfCode
@testable import _2024

@Test private func examplesDay03() throws {
  #expect(Day03(data: example1).part1() == 161)
  #expect(Day03(data: example2).part2() == 48)
}

@Test private func puzzleDay03() throws {
  #expect(Day03().part1() == 178_538_786)
  #expect(Day03().part2() == 102_467_299)
}

private let example1 = "xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))"
private let example2 = "xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))"
