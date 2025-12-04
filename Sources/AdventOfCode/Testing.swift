import Foundation

/// Result of running a day's part
public enum PartResult<T: Equatable>: Equatable {
    case result(T)
    case unimplemented

    public static func == (lhs: PartResult<T>, rhs: T?) -> Bool {
        guard let rhs else { return true }  // nil expected = skip test
        if case .result(let value) = lhs { return value == rhs }
        return true  // unimplemented always "passes"
    }
}

/// Run a day's part and return the result
public func runPart<T: Equatable>(_ part: () throws -> T) -> PartResult<T> {
    do {
        return .result(try part())
    } catch is PartUnimplemented {
        return .unimplemented
    } catch {
        fatalError("Unexpected error: \(error)")
    }
}

/// Run an async day's part and return the result
public func runPart<T: Equatable>(_ part: () async throws -> T) async -> PartResult<T> {
    do {
        return .result(try await part())
    } catch is PartUnimplemented {
        return .unimplemented
    } catch {
        fatalError("Unexpected error: \(error)")
    }
}
