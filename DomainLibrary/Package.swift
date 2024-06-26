// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DomainLibrary",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DomainLibrary",
            targets: ["DomainLibrary"]),
        .library(
            name: "DomainLibrary_Imp",
            targets: ["DomainLibrary_Imp"]),
    ],
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory.git", from: "2.3.1"),
        .package(path: "../Services"),
        .package(path: "../CoreLibrary"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "DomainLibrary",
            dependencies: ["Factory", "Services"]),
        .target(
            name: "DomainLibrary_Imp",
            dependencies: ["DomainLibrary", "Factory", "CoreLibrary", "Services"]),
        .testTarget(
            name: "DomainLibraryTests",
            dependencies: ["DomainLibrary"]),
    ]
)
