import RegexBuilder

// Challenge: Only use Swift RegexBuilder with TryCapture for parsing and use custom components.
// The point is not to create compact or performant code but to explore the Swift Regex APIs
// and see if there's a good structured way of working with them.

struct Day02: AdventDay {
  // MARK: -

  func part1() -> Int {
    games
      .filter {
        $0.turns.allSatisfy {
          $0.colorPairs.allSatisfy {
            switch $0.destructured {
            case (.red, ...12), (.green, ...13), (.blue, ...14):
              true
            default:
              false
            }
          }
        }
      }
      .sum(of: \.id)
  }

  func part2() -> Int {
    games
      .map { game in
        Dictionary(grouping: game.turns.flatMap(\.colorPairs), by: \.color)
          .values
          .map { $0.max(\.count)! }
          .product()
      }
      .sum()
  }

  // MARK: - Data

  let games: [Game]

  init(data: String) {
    games = Parser.games(from: data)
  }

  // MARK: - Models

  struct Game {
    let id: Int
    let turns: [Turn]
  }

  struct Turn {
    let colorPairs: [ColorPair]
  }

  struct ColorPair {
    let color: Color
    let count: Int

    var destructured: (Color, Int) {
      (color, count)
    }
  }

  enum Color: String {
    case red, green, blue
  }

  // MARK: - Parser

  private enum Parser {
    static func games(from data: String) -> [Game] {
      data.matches(of: GameComponent()).map { $0[GameComponent.capturedValue] }
    }

    struct GameComponent: RegexComponent {
      static let capturedValue = Reference(Game.self)

      static let id = Reference(Int.self)
      static let turns = Reference([Turn].self)

      private static let innerRegex = Regex {
        "Game "
        TryCapture(as: id) {
          OneOrMore(.digit)
        } transform: {
          Int($0)
        }
        ": "
        TryCapture(as: turns) {
          SingleTurnComponent()
          ZeroOrMore {
            "; "
            SingleTurnComponent()
          }
        } transform: {
          $0.matches(of: SingleTurnComponent.capture).map {
            $0[SingleTurnComponent.capturedValue]
          }
        }
      }

      let regex = Regex {
        TryCapture(as: capturedValue) {
          innerRegex
        } transform: { str in
          str.firstMatch(of: innerRegex).map {
            Game(
              id: $0[GameComponent.id],
              turns: $0[GameComponent.turns]
            )
          }
        }
      }
    }

    struct SingleTurnComponent: RegexComponent {
      static let capturedValue = Reference(Turn.self)

      let regex = plainRegex

      static let plainRegex = Regex {
        ColorPairComponent()
        ZeroOrMore {
          ", "
          ColorPairComponent()
        }
      }

      static let capture = Regex {
        TryCapture(as: capturedValue) {
          plainRegex
        } transform: { str in
          Turn(
            colorPairs: str.matches(of: ColorPairComponent.capture).map {
              $0[ColorPairComponent.capturedValue]
            }
          )
        }
      }
    }

    struct ColorPairComponent: RegexComponent {
      static let capturedValue = Reference(ColorPair.self)

      let regex = plainRegex

      static let plainRegex = Regex {
        OneOrMore(.digit)
        One(.whitespace)
        OneOrMore(.word)
      }

      static let captureRegex = Regex {
        TryCapture {
          OneOrMore(.digit)
        } transform: {
          Int($0)
        }

        One(.whitespace)

        TryCapture {
          OneOrMore(.word)
        } transform: {
          Color(rawValue: String($0))
        }
      }

      static let capture = Regex {
        TryCapture(as: capturedValue) {
          plainRegex
        } transform: { str in
          str.firstMatch(of: captureRegex).map {
            let (_, count, color) = $0.output
            return ColorPair(color: color, count: count)
          }
        }
      }
    }
  }
}
