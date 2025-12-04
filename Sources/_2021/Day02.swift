// MARK: Day 2: Dive! -

import AdventOfCode

@Day struct Day02 {
    // MARK: -

    func part1() -> Int {
        let (x, y) = commands.reduce((0, 0)) { acc, command in
            switch command.action {
            case "up": (acc.0, acc.1 - command.value)
            case "down": (acc.0, acc.1 + command.value)
            case "forward": (acc.0 + command.value, acc.1)
            default: fatalError()
            }
        }
        return x * y
    }

    func part2() -> Int {
        let (x, y, _) = commands.reduce((0, 0, 0)) { acc, command in
            switch command.action {
            case "up": (acc.0, acc.1, acc.2 - command.value)
            case "down": (acc.0, acc.1, acc.2 + command.value)
            case "forward": (acc.0 + command.value, acc.1 + command.value * acc.2, acc.2)
            default: fatalError()
            }
        }
        return x * y
    }

    // MARK: - Data

    let commands: [(action: Substring, value: Int)]

    init(data: String) {
        self.commands = data.lines().map { ($0.split(separator: " ").splat { ($0, Int($1)!) }) }
    }
}
