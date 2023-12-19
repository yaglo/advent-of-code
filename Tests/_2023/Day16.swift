import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examplesDay16() async throws {
  #expect(Day16(data: example).part1() == 46)
  #expect(try await Day16(data: example).part2() == 51)
}

//@Test private func puzzleDay16() async throws {
//  #expect(Day16().part1() == 7210)
//  #expect(try await Day16().part2() == 7673)
//}

private let example = """
  .|...\\....
  |.-.\\.....
  .....|-...
  ........|.
  ..........
  .........\\
  ..../.\\\\..
  .-.-/..|..
  .|....-|.\\
  ..//.|....
  """
