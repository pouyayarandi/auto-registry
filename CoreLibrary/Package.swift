// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoreLibrary",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "CoreLibrary",
            targets: ["CoreLibrary"]),
        .library(
            name: "CoreLibrary_Imp",
            targets: ["CoreLibrary_Imp"]),
        .library(
            name: "CoreLibrary_Wiring",
            targets: ["CoreLibrary_Wiring"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.1"),
        .package(path: "../MyLibrary")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "CoreLibrary",
            dependencies: ["Factory"]),
        .target(
            name: "CoreLibrary_Imp",
            dependencies: ["CoreLibrary", "MyLibrary"]),
        .target(
            name: "CoreLibrary_Wiring",
            dependencies: ["CoreLibrary", "CoreLibrary_Imp", "Factory"]),
        .testTarget(
            name: "CoreLibraryTests",
            dependencies: ["CoreLibrary"]),
    ]
)
