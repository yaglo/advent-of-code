// swift-tools-version: 5.9
import PackageDescription

let dependencies: [Target.Dependency] = [
  .product(name: "Algorithms", package: "swift-algorithms"),
  .product(name: "ArgumentParser", package: "swift-argument-parser"),
  .product(name: "Collections", package: "swift-collections"),
  .product(name: "Numerics", package: "swift-numerics"),
  .product(name: "SE0270_RangeSet", package: "swift-se0270-range-set"),
]

let swiftSettings: [SwiftSetting] = [
  .enableUpcomingFeature("BareSlashRegexLiterals")
]

let package = Package(
  name: "AdventOfCode",
  platforms: [.macOS(.v13)],
  dependencies: [
    .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
    .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0")),
    .package(
      url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.2.0")),
    .package(url: "https://github.com/apple/swift-format.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-numerics.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
    .package(url: "https://github.com/apple/swift-se0270-range-set", from: "1.0.0"),
    .package(url: "https://github.com/ordo-one/package-benchmark", .upToNextMajor(from: "1.4.0")),
  ],
  targets: [
    .executableTarget(
      name: "Runner",
      dependencies: dependencies + ["AdventOfCode", "_2023"],
      packageAccess: true,
      swiftSettings: swiftSettings
    ),
    .target(
      name: "AdventOfCode",
      dependencies: dependencies,
      packageAccess: true,
      swiftSettings: swiftSettings
    ),
    .target(
      name: "_2023",
      dependencies: dependencies + ["AdventOfCode"],
      resources: [.copy("Data")],
      packageAccess: true,
      swiftSettings: swiftSettings
    ),
    .testTarget(
      name: "Tests_2023",
      dependencies: [
        "AdventOfCode",
        "_2023",
        .product(name: "Testing", package: "swift-testing"),
      ],
      swiftSettings: swiftSettings
    ),
  ]
)

// Benchmark of AdventOfBenchmark
package.targets += [
  .executableTarget(
    name: "Benchmarks",
    dependencies: [
      "AdventOfCode",
      "_2023",
      .product(name: "Benchmark", package: "package-benchmark"),
    ],
    path: "Benchmarks/Benchmarks",
    plugins: [
      .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
    ]
  )
]
