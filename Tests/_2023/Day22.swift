import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examplesDay22() throws {
  #expect(Day22(data: example).part1() == 5)
  #expect(Day22(data: example).part2() == 7)
}

@Test private func puzzleDay22() throws {
  #expect(Day22().part1() == 454)
  #expect(Day22().part2() == 74287)
}

private let example = """
  1,0,1~1,2,1
  0,0,2~2,0,2
  0,2,3~2,2,3
  0,0,4~0,2,4
  2,0,5~2,2,5
  0,1,6~2,1,6
  1,1,8~1,1,9
  """
