// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pokemon_presentation",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .watchOS(.v26),
        .visionOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "pokemon_presentation",
            targets: ["pokemon_presentation"]
        ),
    ],
    dependencies: [
        // If pokemon_shared is a local package in your workspace, adjust the path accordingly.
        .package(name: "pokemon_shared", path: "../pokemon_shared"),
        .package(name: "pokemon_design_system", path: "../pokemon_design_system"),
        .package(name: "pokemon_data", path: "../pokemon_data"),
        .package(name: "pokemon_domain", path: "../pokemon_domain")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "pokemon_presentation",
            dependencies: [
                .product(name: "pokemon_shared", package: "pokemon_shared"),
                .product(name: "pokemon_design_system", package: "pokemon_design_system"),
                .product(name: "pokemon_data", package: "pokemon_data"),
                .product(name: "pokemon_domain", package: "pokemon_domain")
            ]
        ),
        .testTarget(
            name: "pokemon_presentationTests",
            dependencies: ["pokemon_presentation"]
        ),
    ]
)

