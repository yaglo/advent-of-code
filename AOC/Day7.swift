import Foundation

struct Day7: Day {
    let input: String

    func part1() -> Int {
        solve(withJokers: false)
    }

    func part2() -> Int {
        solve(withJokers: true)
    }

    func solve(withJokers: Bool) -> Int {
        input.split(whereSeparator: \.isNewline).map { line in
            let components = line.split(separator: " ")
            return Game(string: String(components[0]), bid: Int(components[1])!, withJokers: withJokers)
        }
        .sorted()
        .enumerated()
        .reduce(0) { partialResult, iterator in
            partialResult + (iterator.offset + 1) * iterator.element.bid
        }
    }

    init(_ input: String) {
        self.input = input
    }

    enum HandType: Int, Comparable {
        case fiveOfAKind, fourOfAKind, fullHouse, threeOfAKind, twoPair, onePair, highCard

        static func < (lhs: Day7.HandType, rhs: Day7.HandType) -> Bool {
            lhs.rawValue > rhs.rawValue
        }
    }

    enum Card: Comparable, Hashable {
        case joker
        case number(Int)
        case jack, queen, king, ace

        var value: Int {
            switch self {
            case .joker: 1
            case .number(let int): int
            case .jack: 11
            case .queen: 12
            case .king: 13
            case .ace: 14
            }
        }

        init(_ character: Character) {
            self =
                switch character {
                case "T": .number(10)
                case "J": .jack
                case "Q": .queen
                case "K": .king
                case "A": .ace
                default: .number(Int(String(character))!)
                }
        }

        static func < (lhs: Card, rhs: Card) -> Bool {
            lhs.value < rhs.value
        }
    }

    struct Game: Comparable {
        let hand: [Card]
        let bid: Int
        let type: HandType

        init(string: String, bid: Int, withJokers: Bool) {
            self.bid = bid

            self.hand = string.map {
                if $0 == "J" {
                    withJokers ? .joker : .jack
                } else {
                    Card($0)
                }
            }

            var cards = Dictionary(grouping: hand, by: \.hashValue)
                .values
                .map { $0 as [Card] }
                .sorted { $0.count > $1.count }

            if withJokers,
                let jokersIndex = cards.firstIndex(where: { $0.contains(.joker) })
            {
                let jokers = cards[jokersIndex]
                cards.remove(at: jokersIndex)

                if cards.count > 0 {
                    cards[0].append(contentsOf: jokers)
                } else {
                    cards = [jokers]
                }
            }

            type =
                switch cards[0].count {
                case 5: .fiveOfAKind
                case 4: .fourOfAKind
                case 3: cards.count == 2 ? .fullHouse : .threeOfAKind
                case 2: cards[1].count == 2 ? .twoPair : .onePair
                case 1: .highCard
                default:
                    fatalError()
                }
        }

        static func < (lhs: Game, rhs: Game) -> Bool {
            if lhs.type == rhs.type {
                for index in lhs.hand.indices where lhs.hand[index] != rhs.hand[index] {
                    return lhs.hand[index] < rhs.hand[index]
                }
            }
            return lhs.type < rhs.type
        }
    }
}
