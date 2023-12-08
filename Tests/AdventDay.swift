import XCTest

@testable import AdventOfCode

// One off test to validate that basic data load testing works
final class AdventDayTests: XCTestCase {
  func testInitData() throws {
    let challenge = Day01()
    XCTAssertTrue(challenge.data.starts(with: "76xkqjzqtwonfour"))
  }
}
