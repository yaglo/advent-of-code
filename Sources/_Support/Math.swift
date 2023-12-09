import Numerics

func lcm<T: BinaryInteger>(_ a: T, _ b: T) -> T {
  a * b / gcd(a, b)
}
