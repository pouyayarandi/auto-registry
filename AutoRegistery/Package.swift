// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutoRegistery",
    platforms: [.iOS(.v13), .macOS(.v11)],
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "AutoRegistery",
            targets: ["AutoRegistery"]),
        .library(
            name: "Registery",
            targets: ["Registery"])
    ],
    dependencies: [
        .package(path: "../MyLibrary"),
        .package(path: "../CoreLibrary"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "AutoRegistery",
            capability: .command(intent: .custom(verb: "register-services", description: ""), permissions: [
                .writeToPackageDirectory(reason: "")
            ])
        ),
        .target(
            name: "Registery",
            dependencies: [
                .product(name: "MyLib_Wiring", package: "MyLibrary"),
                .product(name: "CoreLibrary_Wiring", package: "CoreLibrary"),
            ]
        )
    ]
)
