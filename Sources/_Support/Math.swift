func gcd<T: BinaryInteger>(_ a: T, _ b: T) -> T {
  b == 0 ? a : gcd(b, a % b)
}

func lcm<T: BinaryInteger>(_ a: T, _ b: T) -> T {
  a * b / gcd(a, b)
}
