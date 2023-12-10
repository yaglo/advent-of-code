@_exported import Algorithms
@_exported import Collections
import Foundation

public protocol AdventDay {
  associatedtype Answer = Int

  /// The year and day of the Advent of Code challenge.
  ///
  /// You can implement this property, or, if your type is named with the
  /// day number as its suffix (like `Day01`), and the package is named
  /// as `_YYYY`, it is derived automatically.
  static var yearDay: (Int, Int) { get }

  /// An initializer that uses the provided test data.
  init(data: String)

  /// Computes and returns the answer for part one.
  func part1() async throws -> Answer

  /// Computes and returns the answer for part two.
  func part2() async throws -> Answer
}

public struct PartUnimplemented: Error {
  public let year: Int
  public let day: Int
  public let part: Int
}

extension AdventDay {
  // Find the challenge day from the type name.
  public static var yearDay: (Int, Int) {
    let typeName = String(reflecting: Self.self)
    let components = typeName.dropFirst().split(separator: ".")
    guard components.count == 2, let year = Int(components[0]), components[1].hasPrefix("Day"),
      let day = Int(components[1].dropFirst(3))
    else {
      fatalError(
        """
        Year or day number not found in type name: \
        the package must be named `_YYYY` or you need to \
        implement the static `day` property \
        or use the day number as your type's suffix (like `Day3`).")
        """
      )
    }
    return (year, day)
  }

  public var yearDay: (Int, Int) {
    Self.yearDay
  }

  // Default implementation of `part2`, so there aren't interruptions before
  // working on `part1()`.
  public func part2() throws -> Answer {
    throw PartUnimplemented(year: yearDay.0, day: yearDay.1, part: 2)
  }

  /// An initializer that loads the test data from the corresponding data file.
  public init() {
    self.init(data: Self.loadData(challengeYearDay: Self.yearDay))
  }

  public static func loadData(challengeYearDay: (Int, Int)) -> String {
    let yearString = String(format: "%04d", challengeYearDay.0)
    let dayString = String(format: "%02d", challengeYearDay.1)
    let dataFilename = "Day\(dayString)"

    // TODO: fix path detection
    let dataURL = Bundle(path: "~/Projects/Personal/advent-of-code/Sources")?.url(
      forResource: dataFilename,
      withExtension: "txt",
      subdirectory: "_\(yearString)/Data"
    )

    guard let dataURL,
      let data = try? String(contentsOf: dataURL, encoding: .utf8)
    else {
      fatalError("Couldn't find file '\(dataFilename).txt' in the 'Data' directory.")
    }

    // On Windows, line separators may be CRLF. Converting to LF so that \n
    // works for string parsing.
    return data.replacingOccurrences(of: "\r", with: "")
  }
}
