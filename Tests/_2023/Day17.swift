import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examplesDay17() throws {
  #expect(Day17(data: example).part1() == 102)
  #expect(Day17(data: example).part2() == 94)
}

@Test private func puzzleDay17() throws {
  #expect(Day17().part1() == 1128)
  #expect(Day17().part2() == 1268)
}

private let example = """
  2413432311323
  3215453535623
  3255245654254
  3446585845452
  4546657867536
  1438598798454
  4457876987766
  3637877979653
  4654967986887
  4564679986453
  1224686865563
  2546548887735
  4322674655533
  """
