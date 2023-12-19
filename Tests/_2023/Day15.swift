import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examplesDay15() throws {
  #expect(Day15(data: example).part1() == 1320)
  #expect(Day15(data: example).part2() == 145)
}

//@Test private func puzzleDay15() throws {
//  #expect(Day15().part1() == 517551)
//  #expect(Day15().part2() == 286097)
//}

private let example = """
  rn=1,cm-,qp=3,cm=2,qp-,pc=4,ot=9,ab=5,pc-,pc=6,ot=7
  """
