// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AutoRegistery",
    platforms: [.iOS(.v13)],
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "AutoRegistery",
            targets: ["AutoRegistery"]),
        .plugin(
            name: "RegisteryChecker",
            targets: ["RegisteryChecker"]),
        .library(
            name: "Registery",
            targets: ["Registery"])
    ],
    dependencies: [
        .package(path: "../CoreLibrary"),
        .package(path: "../DomainLibrary"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "AutoRegistery",
            capability: .command(
                intent: .custom(verb: "generate-registery", description: ""),
                permissions: [
                    .writeToPackageDirectory(
                        reason: """
                        In order to generate registery file it
                        will be needed to have write permission
                        """)
                ])
        ),
        .plugin(
            name: "RegisteryChecker",
            capability: .buildTool()
        ),
        .target(
            name: "Registery",
            dependencies: [
                .product(name: "CoreLibrary_Imp", package: "CoreLibrary"),
                .product(name: "DomainLibrary_Imp", package: "DomainLibrary"),
            ]
        )
    ]
)
