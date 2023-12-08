import XCTest

@testable import AdventOfCode

final class Day08Tests: XCTestCase {
  let testData1 = """
    LLR

    AAA = (BBB, BBB)
    BBB = (AAA, ZZZ)
    ZZZ = (ZZZ, ZZZ)
    """

  let testData2 = """
    LR

    11A = (11B, XXX)
    11B = (XXX, 11Z)
    11Z = (11B, XXX)
    22A = (22B, XXX)
    22B = (22C, 22C)
    22C = (22Z, 22Z)
    22Z = (22B, 22B)
    XXX = (XXX, XXX)
    """

  func testPart1() throws {
    let challenge = Day08(data: testData1)
    XCTAssertEqual(String(describing: challenge.part1()), "6")
  }

  func testPart2() throws {
    let challenge = Day08(data: testData2)
    XCTAssertEqual(String(describing: challenge.part2()), "6")
  }

  func testPuzzleAnswer() throws {
    let challenge = Day08()
    XCTAssertEqual(String(describing: challenge.part1()), "16343")
    XCTAssertEqual(String(describing: challenge.part2()), "15299095336639")
  }
}
