// MARK: Day 22: Sand Slabs -

import AdventOfCode
import Collections

@Day struct Day22 {
    // MARK: -

    func part1() -> Int {
        var bricks = bricks
        fallDown(bricks: &bricks)
        return bricks.filter { $0.canBeDisintegrated(in: bricks) }.count
    }

    func part2() -> Int {
        var total = 0
        var bricks = bricks
        fallDown(bricks: &bricks)

        var supporters = [[Int]](repeating: [], count: bricks.count)
        var supporting = [[Int]](repeating: [], count: bricks.count)
        var allChildren = [Set<Int>?](repeating: nil, count: bricks.count)

        for brick in bricks {
            let supported = bricks.filter { $0.isSupported(by: brick) }
            for other in supported {
                supporting[brick.id].append(other.id)
                supporters[other.id].append(brick.id)
            }
        }

        for brick in bricks.reversed() {
            let directlySupported = supporting[brick.id]
            guard directlySupported.count > 0,
                !directlySupported.contains(where: { supporters[$0].count > 1 })
            else {
                continue
            }

            if let children = allChildren[brick.id] {
                total += children.count
            } else {
                var children = Set(directlySupported)
                var queue = Deque(directlySupported)

                while let brick = queue.popFirst() {
                    if let subchildren = allChildren[brick] {
                        children.formUnion(subchildren)
                    } else {
                        let bricks = supporting[brick]
                        queue.append(contentsOf: bricks)
                        children.formUnion(bricks)
                    }
                }
                allChildren[brick.id] = children
                total += children.count
            }
        }

        return total
    }

    func fallDown(bricks: inout [Brick]) {
        for i in 0..<bricks.count {
            let z = bricks[i].z
            var zl = z.lowerBound
            while zl > 1
                && !bricks.contains(where: { other in
                    zl - 1 == other.z.upperBound && other.xyOverlaps(bricks[i])
                })
            { zl -= 1 }
            bricks[i].z = zl...zl + z.count - 1
        }
    }

    // MARK: - Data

    let bricks: [Brick]

    init(data: String) {
        bricks = data.lines().enumerated()
            .map { index, line in
                let (lower, upper) = line.split(separator: "~").map {
                    $0.integers(separatedBy: ",")
                }
                .splat()
                return Brick(
                    id: index, x: lower[0]...upper[0], y: lower[1]...upper[1],
                    z: lower[2]...upper[2])
            }
            .sorted(by: \.z.lowerBound)
    }

    // MARK: - Models

    struct Brick: CustomStringConvertible {
        let id: Int

        let x: ClosedRange<Int>
        let y: ClosedRange<Int>
        var z: ClosedRange<Int>

        var description: String {
            "\(id) \(x.lowerBound),\(y.lowerBound),\(z.lowerBound)~\(x.upperBound),\(y.upperBound),\(z.upperBound)"
        }

        func xyOverlaps(_ other: Brick) -> Bool { x.overlaps(other.x) && y.overlaps(other.y) }

        func isSupported(by other: Brick) -> Bool {
            xyOverlaps(other) && z.lowerBound == other.z.upperBound + 1
        }

        func canBeDisintegrated(in bricks: [Brick]) -> Bool {
            !bricks.lazy.filter { $0.isSupported(by: self) }
                .contains { brick in !bricks.contains { $0.id != id && brick.isSupported(by: $0) } }
        }
    }
}
