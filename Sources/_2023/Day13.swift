// MARK: Day 13: Point of Incidence -

import AdventOfCode
import Algorithms

@Day struct Day13 {
    // MARK: -

    func part1() -> Int {
        var sum = 0

        for map in maps { if let result = findMirror(map: map) { sum += result } }
        return sum
    }

    func part2() -> Int {
        var sum = 0

        for map in maps {
            let originalResult = findMirror(map: map)!
            let smudges = findSmudges(map: map)
            var newResults = Set(
                smudges.compactMap { smudge in
                    var newMap = map
                    newMap[smudge.row][smudge.column] = smudge.newElement
                    return findMirror(map: newMap, differentFrom: originalResult)
                }
            )
            newResults.remove(originalResult)
            sum += newResults.first ?? originalResult
        }
        return sum
    }

    func findSmudges(map: [[Int]]) -> Set<Smudge> {
        var smudges: Set<Smudge> = []

        for i in map.indices {
            for j in map.indices where i != j {
                let one = map[i]
                let two = map[j]
                let diff = one.difference(from: two)
                if diff.removals.count == 1, case .remove(let offset, let element, _) = diff.removals.first {
                    smudges.insert(Smudge(row: j, column: offset, newElement: element == 1 ? 0 : 1))
                }
            }
        }
        for i in map[0].indices {
            for j in map[0].indices where i != j {
                let one = map[column: i]
                let two = map[column: j]
                let diff = one.difference(from: two)
                if diff.insertions.count == 1,
                    case .insert(let offset, let element, _) = diff.insertions.first
                {
                    smudges.insert(Smudge(row: offset, column: i, newElement: element == 1 ? 0 : 1))
                }
            }
        }
        return smudges
    }

    struct Smudge: Hashable { let row, column, newElement: Int }

    func findMirror(map: [[Int]], differentFrom otherResult: Int? = nil) -> Int? {
        var size = map[0].count

        for width in stride(from: size / 2, through: 1, by: -1) {
            for offset in [0, size - width * 2] {
                var left: [[Int]] = []
                var right: [[Int]] = []

                for column in 0..<width {
                    let l = map[column: column + offset]
                    let r = map[column: offset + width * 2 - 1 - column]
                    left.append(l)
                    right.append(r)
                }

                if left == right {
                    let result = offset + width
                    if result != otherResult { return offset + width }
                }
            }
        }

        size = map.count
        for width in stride(from: size / 2, through: 1, by: -1) {
            for offset in [0, size - width * 2] {
                var top: [[Int]] = []
                var bottom: [[Int]] = []

                for row in 0..<width {
                    let t = map[row + offset]
                    let b = map[offset + width * 2 - 1 - row]
                    top.append(t)
                    bottom.append(b)
                }

                if top == bottom {
                    let result = (offset + width) * 100
                    if result != otherResult { return result }
                }
            }
        }
        return nil
    }

    // MARK: - Data

    let maps: [[[Int]]]

    init(data: String) {
        maps = data.split(separator: "\n\n").map {
            $0.split(separator: "\n").map { $0.map { $0 == "." ? 0 : 1 } }
        }
    }
}
