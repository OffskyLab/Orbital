// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "orbital",
    platforms: [.macOS(.v13)],
    products: [
        .executable(name: "orbital", targets: ["orbital"]),
        .library(name: "OrbitalCore", targets: ["OrbitalCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
    ],
    targets: [
        .executableTarget(
            name: "orbital",
            dependencies: ["OrbitalCore"],
            path: "Sources/orbital"
        ),
        .target(
            name: "OrbitalCore",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ],
            path: "Sources/OrbitalCore"
        ),
        .testTarget(
            name: "OrbitalTests",
            dependencies: ["OrbitalCore"],
            path: "Tests/OrbitalTests"
        ),
    ]
)
