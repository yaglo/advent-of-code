import XCTest
import Testing
@testable import AdventOfCode

final class AllTests: XCTestCase {
  func testAll() async {
    await XCTestScaffold.runAllTests(hostedBy: self)
  }
}
