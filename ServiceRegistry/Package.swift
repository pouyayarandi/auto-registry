// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let registryDependencies: [Target.Dependency] = [
    .serviceProduct(name: "CoreLibrary"),
    .serviceProduct(name: "DomainLibrary"),
]

let package = Package(
    name: "ServiceRegistry",
    platforms: [.iOS(.v13)],
    products: [
        // Products can be used to vend plugins, making them visible to other packages.
        .plugin(
            name: "ServiceRegistry",
            targets: ["ServiceRegistry"]),
        .plugin(
            name: "RegistryChecker",
            targets: ["RegistryChecker"]),
        .library(
            name: "Registry",
            targets: ["Registry"])
    ],
    dependencies: registryDependencies
        .compactMap(\.package)
        .map({ .package(path: "../\($0)") }),
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .plugin(
            name: "ServiceRegistry",
            capability: .command(
                intent: .custom(verb: "generate-registry", description: ""),
                permissions: [
                    .writeToPackageDirectory(
                        reason: """
                        In order to generate registry file it
                        will be needed to have write permission
                        """)
                ])
        ),
        .plugin(
            name: "RegistryChecker",
            capability: .buildTool()
        ),
        .target(
            name: "Registry",
            dependencies: registryDependencies
        )
    ]
)

extension Target.Dependency {
    var package: String? {
        if case .productItem(name: _, package: let p, moduleAliases: _, condition: _) = self {
            return p
        }
        return nil
    }

    static func serviceProduct(name: String) -> Self {
        return .product(name: "\(name)_Imp", package: name)
    }
}
