import XCTest

@testable import AdventOfCode

final class Day01Tests: XCTestCase {
  let testData1 = """
    1abc2
    pqr3stu8vwx
    a1b2c3d4e5f
    treb7uchet
    """

  let testData2 = """
    two1nine
    eightwothree
    abcone2threexyz
    xtwone3four
    4nineeightseven2
    zoneight234
    7pqrstsixteen
    """

  func testPart1() throws {
    let challenge = Day01(data: testData1)
    XCTAssertEqual(String(describing: challenge.part1()), "142")
  }

  func testPart2() throws {
    let challenge = Day01(data: testData2)
    XCTAssertEqual(String(describing: challenge.part2()), "281")
  }

  func testPuzzleAnswer() throws {
    let challenge = Day01()
    XCTAssertEqual(String(describing: challenge.part1()), "54644")
    XCTAssertEqual(String(describing: challenge.part2()), "53348")
  }
}
