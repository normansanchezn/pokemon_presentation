// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "pokemon_presentation",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "pokemon_presentation",
            targets: ["pokemon_presentation"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "pokemon_presentation"
        ),
        .testTarget(
            name: "pokemon_presentationTests",
            dependencies: ["pokemon_presentation"]
        ),
    ]
)
