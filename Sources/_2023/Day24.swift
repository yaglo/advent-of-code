// MARK: Day 24: Never Tell Me The Odds -

import AdventOfCode
import Foundation
import PythonKit

struct Day24: AdventDay {
  // MARK: -

  func part1() -> Int {
    let range = 200_000_000_000_000.0...400_000_000_000_000.0
    return hailstones.combinations(ofCount: 2)
      .reduce(0) { partialResult, combination in
        partialResult
          + (intersect(combination[0], combination[1], in: (x: range, y: range)) ? 1 : 0)
      }
  }

  func intersect(
    _ objectA: Hailstone,
    _ objectB: Hailstone,
    in boundingBox: (x: ClosedRange<Double>, y: ClosedRange<Double>)
  ) -> Bool {
    let (t, u) = intersectionTimes(objectA, objectB)
    guard t >= 0, u >= 0 else { return false }
    let pA = objectA.position(at: t)
    let pB = objectB.position(at: u)
    return boundingBox.x.contains(pA.x) && boundingBox.y.contains(pA.y)
      && boundingBox.x.contains(pB.x) && boundingBox.y.contains(pB.y)
  }

  func intersectionTimes(_ objectA: Hailstone, _ objectB: Hailstone) -> (Double, Double) {
    let (px1, py1, vx1, vy1) = (
      objectA.coordinate.x, objectA.coordinate.y, objectA.direction.x, objectA.direction.y
    )
    let (px2, py2, vx2, vy2) = (
      objectB.coordinate.x, objectB.coordinate.y, objectB.direction.x, objectB.direction.y
    )
    let u = (py2 - py1 - vy1 * (px2 - px1) / vx1) / (vy1 * vx2 / vx1 - vy2)
    let t = (px2 - px1 + vx2 * u) / vx1
    return (t, u)
  }

  func part2() -> Int {
    let s = Python.import("sympy")
    let equations = hailstones.prefix(3).enumerated()
      .flatMap { i, hailstone in
        [
          s.Eq(
            s.sympify("x + dx * t\(i)"),
            s.sympify("\(Int(hailstone.coordinate.x)) + \(Int(hailstone.direction.x)) * t\(i)")
          ),
          s.Eq(
            s.sympify("y + dy * t\(i)"),
            s.sympify("\(Int(hailstone.coordinate.y)) + \(Int(hailstone.direction.y)) * t\(i)")
          ),
          s.Eq(
            s.sympify("z + dz * t\(i)"),
            s.sympify("\(Int(hailstone.coordinate.z)) + \(Int(hailstone.direction.z)) * t\(i)")
          ),
        ]
      }

    let (x, y, z) = s.solve(equations, s.symbols("x y z dx dy dz t0 t1 t2"))[0].tuple3
    return Int(x)! + Int(y)! + Int(z)!
  }

  // MARK: - Models

  struct Coordinate3D: Hashable, CustomStringConvertible {
    let x, y, z: Double

    var description: String { "(\(x),\(y),\(z)" }

    static func + (lhs: Coordinate3D, rhs: Coordinate3D) -> Coordinate3D {
      Coordinate3D(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
    }

    func isParallel(to other: Coordinate3D) -> Bool {
      let crossProd = self * other
      return crossProd.x.isZero && crossProd.y.isZero && crossProd.z.isZero
    }

    static func * (lhs: Coordinate3D, rhs: Coordinate3D) -> Coordinate3D {
      let newX = lhs.y * rhs.z - lhs.z * rhs.y
      let newY = lhs.z * rhs.x - lhs.x * rhs.z
      let newZ = lhs.x * rhs.y - lhs.y * rhs.x
      return Coordinate3D(x: newX, y: newY, z: newZ)
    }

    var reversed: Coordinate3D { Coordinate3D(x: -x, y: -y, z: -z) }
  }

  struct Hailstone: Hashable, RawRepresentable {
    var id: Int
    var coordinate: Coordinate3D
    var direction: Coordinate3D

    init?(rawValue: String) {
      id = UUID().hashValue
      let (coordinate, vector) = rawValue.split(separator: " @ ")
        .map {
          $0.split(separator: ",").map { $0.trimmingCharacters(in: CharacterSet.whitespaces) }
            .map { Double($0)! }
        }
        .splat()
      self.coordinate = Coordinate3D(x: coordinate[0], y: coordinate[1], z: coordinate[2])
      self.direction = Coordinate3D(x: vector[0], y: vector[1], z: vector[2])
    }

    var rawValue: String {
      "\(coordinate.x), \(coordinate.y), \(coordinate.z) @ \(direction.x), \(direction.y), \(direction.z)"
    }

    func position(at time: Double) -> Coordinate3D {
      let displacement = Coordinate3D(
        x: direction.x * time,
        y: direction.y * time,
        z: direction.z * time
      )
      return coordinate + displacement
    }
  }

  let hailstones: [Hailstone]

  init(data: String) { hailstones = data.mapLines { Hailstone(rawValue: String($0))! } }
}
