import Accelerate
import Numerics

public func lcm<T: BinaryInteger>(_ a: T, _ b: T) -> T { a * b / gcd(a, b) }

public func rotateMatrix(_ matrix: inout [[Float]], ccw: Bool = false) {
  let input: [Float] = Array(matrix.joined())
  var output: [Float] = Array(repeating: 0, count: input.count)

  let M = Int32(matrix.count)
  let N = Int32(matrix[0].count)

  let inputStride = vDSP_Stride(1)
  let outputStride = vDSP_Stride(1)

  vDSP_mtrans(input, inputStride, &output, outputStride, vDSP_Length(N), vDSP_Length(M))

  matrix =
    if ccw { output.chunks(ofCount: Int(M)).reversed().map { Array($0) } } else {
      output.chunks(ofCount: Int(M)).map { $0.reversed() }
    }
}

public func flipMatrix(_ matrix: inout [[Float]]) {
  for i in matrix.indices { matrix[i].reverse() }
}
