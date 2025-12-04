// MARK: Day 16: The Floor Will Be Lava -

import AdventOfCode
import Foundation

@Day struct Day16 {
    // MARK: -

    enum Tile { case empty, vsplit, hsplit, forward, backward }

    struct Coordinate: Hashable { let x, y: Int }

    func part1() -> Int { energize(Beam(position: .init(x: 0, y: 0), direction: (1, 0))) }

    func part2() async -> Int {
        await withTaskGroup(of: Int.self) { group in
            for y in 0..<grid.count {
                group.addTask { energize(Beam(position: .init(x: 0, y: y), direction: (1, 0))) }
                group.addTask {
                    energize(Beam(position: .init(x: grid[0].count - 1, y: y), direction: (-1, 0)))
                }
            }

            for x in 0..<grid[0].count {
                group.addTask { energize(.init(position: .init(x: x, y: 0), direction: (0, 1))) }
                group.addTask {
                    energize(Beam(position: Coordinate(x: x, y: grid.count - 1), direction: (0, -1)))
                }
            }

            return await group.reduce(Int.min) { partialResult, energized in max(partialResult, energized)
            }
        }
    }

    func energize(_ beam: Beam) -> Int {
        var beams: [Beam] = [beam]
        var energized: Set<Coordinate> = []
        let height = grid.count
        let width = grid[0].count
        var noChanges = max(width, height)
        while noChanges > 0 {
            for i in beams.indices {
                let beam = beams[i]
                switch grid[beam.position.y][beam.position.x] {
                case .backward: beams[i].direction = (beam.direction.y, beam.direction.x)
                case .forward: beams[i].direction = (-beam.direction.y, -beam.direction.x)
                case .vsplit:
                    if beam.direction.x == 0 { continue }
                    beams[i].direction = (0, -1)
                    var beam2 = beam
                    beam2.direction = (0, 1)
                    beams.append(beam2)
                case .hsplit:
                    if beam.direction.y == 0 { continue }
                    beams[i].direction = (-1, 0)
                    var beam2 = beam
                    beam2.direction = (1, 0)
                    beams.append(beam2)
                case .empty: break
                }
            }

            var newCellsEnegrized = false
            for i in beams.indices {
                let beam = beams[i]
                if !energized.contains(beam.position) { newCellsEnegrized = true }
                energized.insert(beam.position)
                beams[i].step()
            }
            if !newCellsEnegrized { noChanges -= 1 }
            beams = beams.filter {
                0 <= $0.position.y && $0.position.y < height && 0 <= $0.position.x && $0.position.x < width
            }
        }

        return energized.count
    }

    // MARK: - Data

    let grid: [[Tile]]

    init(data: String) {
        grid = data.split(whereSeparator: \.isNewline)
            .map { line in
                line.map { item -> Tile in
                    switch item {
                    case ".": .empty
                    case "-": .hsplit
                    case "|": .vsplit
                    case "/": .forward
                    case "\\": .backward
                    default: fatalError()
                    }
                }
            }
    }

    struct Beam {
        var position: Coordinate
        var direction: (x: Int, y: Int)

        mutating func step() {
            position = Coordinate(x: position.x + direction.x, y: position.y + direction.y)
        }
    }
}
