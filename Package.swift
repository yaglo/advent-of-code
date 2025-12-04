// swift-tools-version: 6.2
import CompilerPluginSupport
import PackageDescription

let dependencies: [Target.Dependency] = [
    .product(name: "Algorithms", package: "swift-algorithms"),
    .product(name: "ArgumentParser", package: "swift-argument-parser"),
    .product(name: "Collections", package: "swift-collections"),
    .product(name: "Numerics", package: "swift-numerics"),
    .product(name: "SwiftCSP", package: "SwiftCSP"),
    .product(name: "PythonKit", package: "PythonKit"),
]

let swiftSettings: [SwiftSetting] = []

let package = Package(
    name: "AdventOfCode",
    platforms: [.macOS("26.0")],
    dependencies: [
        .package(
            url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.1")),
        .package(url: "https://github.com/apple/swift-collections.git", from: "1.3.0"),
        .package(
            url: "https://github.com/apple/swift-argument-parser.git", .upToNextMajor(from: "1.6.2")
        ),
        .package(url: "https://github.com/apple/swift-numerics.git", from: "1.1.1"),
        .package(url: "https://github.com/apple/swift-testing.git", branch: "main"),
        .package(
            url: "https://github.com/ordo-one/package-benchmark", .upToNextMajor(from: "1.29.6")),
        .package(url: "https://github.com/davecom/SwiftCSP.git", branch: "master"),
        .package(url: "https://github.com/pvieito/PythonKit.git", branch: "master"),
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "603.0.0-latest"),
    ],

    // MARK: - Common
    targets: [
        .executableTarget(
            name: "Runner",
            dependencies: dependencies + ["AdventOfCode", "_2025"],
            packageAccess: true,
            swiftSettings: swiftSettings
        ),

        .target(
            name: "AdventOfCode",
            dependencies: dependencies + ["AdventOfCodeMacros"],
            packageAccess: true,
            swiftSettings: swiftSettings
        ),

        .macro(
            name: "AdventOfCodeMacros",
            dependencies: [
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ]
        ),

        // MARK: - Years

        .target(
            name: "_2015",
            dependencies: dependencies + ["AdventOfCode"],
            resources: [.copy("Data")],
            packageAccess: true,
            swiftSettings: swiftSettings
        ),

        .target(
            name: "_2021",
            dependencies: dependencies + ["AdventOfCode"],
            resources: [.copy("Data")],
            packageAccess: true,
            swiftSettings: swiftSettings
        ),

        .target(
            name: "_2022",
            dependencies: dependencies + ["AdventOfCode"],
            resources: [.copy("Data")],
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

        .target(
            name: "_2024",
            dependencies: dependencies + ["AdventOfCode"],
            resources: [.copy("Data")],
            packageAccess: true,
            swiftSettings: swiftSettings
        ),

        .target(
            name: "_2025",
            dependencies: dependencies + ["AdventOfCode"],
            resources: [.copy("Data")],
            packageAccess: true,
            swiftSettings: swiftSettings
        ),

        // MARK: - Tests

        .testTarget(
            name: "Tests_2015",
            dependencies: [
                "_2015", "AdventOfCode", .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests/_2015",
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "Tests_2021",
            dependencies: [
                "_2021", "AdventOfCode", .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests/_2021",
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "Tests_2022",
            dependencies: [
                "_2022", "AdventOfCode", .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests/_2022",
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "Tests_2023",
            dependencies: [
                "_2023", "AdventOfCode", .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests/_2023",
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "Tests_2024",
            dependencies: [
                "_2024", "AdventOfCode", .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests/_2024",
            swiftSettings: swiftSettings
        ),

        .testTarget(
            name: "Tests_2025",
            dependencies: [
                "_2025", "AdventOfCode", .product(name: "Testing", package: "swift-testing"),
            ],
            path: "Tests/_2025",
            swiftSettings: swiftSettings
        ),

        // MARK: - Benchmarks

        .executableTarget(
            name: "Benchmarks",
            dependencies: [
                "AdventOfCode",
                "_2025",
                .product(name: "Benchmark", package: "package-benchmark"),
            ],
            path: "Benchmarks/Benchmarks",
            plugins: [
                .plugin(name: "BenchmarkPlugin", package: "package-benchmark")
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)
