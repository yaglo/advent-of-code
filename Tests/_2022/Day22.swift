import Testing

@testable import AdventOfCode
@testable import _2022

@Test private func examples() throws {
  #expect(Day22(data: example).part1() == 6032)
  #expect(Day22(data: example).part2() == 0)
}

//@Test private func puzzle() throws {
//  #expect(Day22().part1() == 0)
//  #expect(Day22().part2() == 0)
//}

@Test private func mapCorner() {
  let day = Day22(data: example)
  let mapper = Day22.CubeMapper(tiles: day.tiles)
  mapper.side = 4
  let (net, seams) = mapper.createNet()
  #expect(net == [[0, 0, 1, 0], [1, 1, 1, 0], [0, 0, 1, 1]])
  print(seams)
}

private let example = """
          ...#
          .#..
          #...
          ....
  ...#.......#
  ........#...
  ..#....#....
  ..........#.
          ...#....
          .....#..
          .#......
          ......#.

  10R5L5R10L4R5L5
  """
