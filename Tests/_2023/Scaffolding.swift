import Testing
import XCTest

@testable import AdventOfCode
@testable import _2023

final class AllTests: XCTestCase {
  func testAll() async {
    await XCTestScaffold.runAllTests(hostedBy: self)
  }
}
