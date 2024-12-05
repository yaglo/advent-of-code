import Testing

@testable import AdventOfCode
@testable import _2023

@Test private func examples_16() async throws {
  #expect(Day16(data: example).part1() == 46)
  #expect(await Day16(data: example).part2() == 51)
}

//@Test private func puzzle_16() async throws {
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
