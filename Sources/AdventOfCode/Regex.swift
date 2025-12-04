import RegexBuilder

extension Capture<(Substring, Int)> {
    public static var integer: TryCapture<(Substring, Int)> {
        TryCapture {
            OneOrMore(.digit)
        } transform: {
            Int($0)!
        }
    }
}

extension Capture<(Substring, [Int])> {
    public static var arrayOfIntegers: TryCapture<(Substring, [Int])> {
        TryCapture {
            OneOrMore {
                OneOrMore(.digit)
                OneOrMore(.whitespace)
            }
            OneOrMore(.digit)
        } transform: {
            $0.matches(of: /\d+/).map { Int($0.output)! }
        }
    }
}

extension Capture<(Substring, Set<Int>)> {
    public static var setOfIntegers: TryCapture<(Substring, Set<Int>)> {
        TryCapture {
            OneOrMore {
                OneOrMore(.digit)
                OneOrMore(.whitespace)
            }
            OneOrMore(.digit)
        } transform: {
            Set($0.matches(of: /\d+/).map { Int($0.output)! })
        }
    }
}
