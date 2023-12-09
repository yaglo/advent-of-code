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
  .enableUpcomingFeature("BareSlashRegexLiterals"),
  .unsafeFlags(["-Xfrontend", "-enable-experimental-string-processing"]),
]

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS(.v13)],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-algorithms.git",
            .upToNextMajor(from: "1.2.0")
        ),
        .package(
            url: "https://github.com/apple/swift-collections.git",
            .upToNextMajor(from: "1.0.0")
        ),
        .package(
            url: "https://github.com/apple/swift-argument-parser.git",
            .upToNextMajor(from: "1.2.0")
        ),
        .package(
            url: "https://github.com/apple/swift-format.git",
            .upToNextMajor(from: "509.0.0")
        ),
        .package(
            url: "https://github.com/apple/swift-numerics.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/apple/swift-testing.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/apple/swift-se0270-range-set",
            from: "1.0.0"
        ),
    ],
    targets: [
        .executableTarget(
            name: "AdventOfCode",
            dependencies: dependencies,
            resources: [.copy("Data")],
            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "AdventOfCodeTests",
            dependencies: [
                "AdventOfCode",
                .product(name: "Testing", package: "swift-testing"),
            ],
            swiftSettings: swiftSettings
        ),
    ]
)
