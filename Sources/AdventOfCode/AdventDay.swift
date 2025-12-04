@_exported import Algorithms
@_exported import Collections
import Foundation

// MARK: - Macro

/// Macro that adds AdventDay conformance and required members to a day struct.
/// Usage: @Day struct Day01 { func part1() -> Int { ... } }
@attached(member, names: named(data), named(init(data:)), named(init()))
@attached(extension, conformances: AdventDay, AdventDayTests)
public macro Day() = #externalMacro(module: "AdventOfCodeMacros", type: "DayMacro")

// MARK: - Protocol

public protocol AdventDay: Sendable {
    associatedtype Answer = Int

    /// The year and day of the challenge, derived automatically from type name
    /// (e.g., `_2025.Day01` -> `(2025, 1)`), or override manually.
    static var yearDay: (Int, Int) { get }

    /// The bundle containing data files. Provide via protocol extension in each year module.
    static var bundle: Bundle { get }

    /// Initialize with test data.
    init(data: String)

    /// Computes and returns the answer for part one.
    func part1() async throws -> Answer

    /// Computes and returns the answer for part two.
    func part2() async throws -> Answer
}

// MARK: - Test Data

/// Protocol for days that provide example test data
public protocol AdventDayTests: AdventDay where Answer: Equatable {
    /// Example input for part 1
    static var examplePart1Input: String { get }

    /// Example input for part 2 (defaults to examplePart1Input)
    static var examplePart2Input: String { get }

    /// Expected answer for part 1 with example input (nil = skip)
    static var examplePart1: Answer? { get }

    /// Expected answer for part 2 with example input (nil = skip)
    static var examplePart2: Answer? { get }

    /// Expected answer for part 1 with real input (nil = skip)
    static var answerPart1: Answer? { get }

    /// Expected answer for part 2 with real input (nil = skip)
    static var answerPart2: Answer? { get }
}

extension AdventDayTests {
    public static var examplePart1Input: String { "" }
    public static var examplePart2Input: String { examplePart1Input }
    public static var examplePart1: Answer? { nil }
    public static var examplePart2: Answer? { nil }
    public static var answerPart1: Answer? { nil }
    public static var answerPart2: Answer? { nil }
}

// MARK: - Errors

public struct PartUnimplemented: Error {
    public let year: Int
    public let day: Int
    public let part: Int
}

// MARK: - Default Implementations

extension AdventDay {
    public static var yearDay: (Int, Int) {
        let typeName = String(reflecting: Self.self)
        let components = typeName.dropFirst().split(separator: ".")
        guard components.count == 2,
            let year = Int(components[0]),
            components[1].hasPrefix("Day"),
            let day = Int(components[1].dropFirst(3))
        else {
            fatalError("Could not derive year/day from type '\(typeName)'. Use _YYYY.DayDD naming.")
        }
        return (year, day)
    }

    public var yearDay: (Int, Int) { Self.yearDay }

    public func part2() throws -> Answer {
        throw PartUnimplemented(year: yearDay.0, day: yearDay.1, part: 2)
    }

    public init() {
        self.init(data: Self.loadData())
    }

    public static func loadData() -> String {
        let (year, day) = yearDay
        let filename = String(format: "Day%02d", day)

        guard
            let url = bundle.url(forResource: filename, withExtension: "txt", subdirectory: "Data"),
            let content = try? String(contentsOf: url, encoding: .utf8)
        else {
            fatalError("Missing: Sources/_\(year)/Data/\(filename).txt")
        }

        return content.replacingOccurrences(of: "\r", with: "")
    }
}
