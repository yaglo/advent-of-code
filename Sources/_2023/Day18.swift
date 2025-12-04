// MARK: Day 18: Lavaduct Lagoon -

import AdventOfCode
import Collections
import Foundation

@Day struct Day18 {
    // MARK: -

    func part1() -> Int {
        struct Coordinate { let x, y: Int }

        func fill(_ bitmap: inout [[Bool]], start: Coordinate) {
            var paintingStack: Deque<Coordinate> = []
            paintingStack.append(start)

            while let coord = paintingStack.popLast() {
                if !bitmap[coord.y][coord.x] {
                    bitmap[coord.y][coord.x] = true

                    for y in max(0, coord.y - 1)...min(bitmap.count - 1, coord.y + 1) {
                        for x in max(0, coord.x - 1)...min(bitmap[0].count - 1, coord.x + 1) {
                            if !bitmap[y][x] { paintingStack.append(.init(x: x, y: y)) }
                        }
                    }
                }
            }
        }

        var coordinates: [Coordinate] = [Coordinate(x: 0, y: 0)]
        var cMin = Coordinate(x: Int.max, y: Int.max)
        var cMax = Coordinate(x: Int.min, y: Int.min)

        for line in data.lines() {
            let parts = line.split(separator: " ")
            let direction = Direction(rawValue: String(parts[0]))!
            let length = Int(parts[1])!

            var x = coordinates.last!.x
            var y = coordinates.last!.y

            switch direction {
            case .left: x -= length
            case .up: y -= length
            case .right: x += length
            case .down: y += length
            }

            coordinates.append(Coordinate(x: x, y: y))
            cMin = Coordinate(x: min(cMin.x, x), y: min(cMin.y, y))
            cMax = Coordinate(x: max(cMax.x, x), y: max(cMax.y, y))
        }

        var grid = [[Bool]](
            repeating: [Bool](repeating: false, count: cMax.x - cMin.x + 1), count: cMax.y - cMin.y + 1)

        var prev = coordinates.removeFirst()

        for coordinate in coordinates {
            for y in stride(
                from: prev.y - cMin.y, through: coordinate.y - cMin.y, by: prev.y > coordinate.y ? -1 : 1)
            {
                for x in stride(
                    from: prev.x - cMin.x, through: coordinate.x - cMin.x, by: prev.x > coordinate.x ? -1 : 1)
                {
                    grid[y][x] = true
                }
            }
            prev = coordinate
        }

        fill(&grid, start: Coordinate(x: (cMax.x - cMin.x) / 2, y: (cMax.y - cMin.y) / 2))

        return grid.joined().count { $0 }
    }

    func part2() -> Int {
        struct Coordinate { var x, y, xAdj, yAdj: Double }

        let instructions = data.mapLines {
            let line = $0.split(separator: " ")
            let length = Int(String(line[2]).dropFirst(2).prefix(5), radix: 16)!
            let directions = [
                "0": Direction.right, "1": Direction.down, "2": Direction.left, "3": Direction.up,
            ]
            let direction = directions[String(line[2].dropLast().last!)]!
            return Instruction(direction: direction, length: length)
        }

        var coordinates: [Coordinate] = [Coordinate(x: 0, y: 0, xAdj: -0.5, yAdj: 0.5)]

        for (i, instruction) in instructions.enumerated() {
            guard i < instructions.count - 1 else {
                coordinates.append(coordinates.first!)
                break
            }

            var x = coordinates.last!.x
            var y = coordinates.last!.y
            let length = Double(instruction.length)

            switch instruction.direction {
            case .left: x -= length
            case .up: y -= length
            case .right: x += length
            case .down: y += length
            }

            let adj =
                switch (instruction.direction, instructions[i + 1].direction) {
                case (.right, .down): (0.5, -0.5)
                case (.down, .left): (0.5, 0.5)
                case (.left, .down): (0.5, 0.5)
                case (.down, .right): (0.5, -0.5)
                case (.left, .up): (-0.5, 0.5)
                case (.up, .right): (-0.5, -0.5)
                case (.right, .up): (-0.5, -0.5)
                case (.up, .left): (-0.5, 0.5)
                default: fatalError()
                }

            coordinates.append(.init(x: x, y: y, xAdj: adj.0, yAdj: adj.1))
        }

        for i in coordinates.indices {
            coordinates[i].x += 0.5
            coordinates[i].y += 0.5
        }

        var area = 0.0
        for i in coordinates.indices.dropLast() {
            area +=
                (coordinates[i].x + coordinates[i].xAdj) * (coordinates[i + 1].y + coordinates[i + 1].yAdj)
                - (coordinates[i + 1].x + coordinates[i + 1].xAdj)
                * (coordinates[i].y + coordinates[i].yAdj)
        }

        return Int(abs(area) / 2)
    }

    // MARK: Models -

    enum Direction: String {
        case left = "L"
        case up = "U"
        case right = "R"
        case down = "D"
    }

    struct Instruction {
        let direction: Direction
        let length: Int
    }
}
