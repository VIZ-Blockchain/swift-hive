// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VIZ",
    products: [
        .library(name: "VIZ", targets: ["VIZ"]),
    ],
    dependencies: [
        .package(url: "https://github.com/Flight-School/AnyCodable.git", .revision("396ccc3dba5bdee04c1e742e7fab40582861401e")),
        .package(url: "https://github.com/lukaskubanek/OrderedDictionary.git", .branch("master")),
    ],
    targets: [
        .target(
            name: "Crypto",
            dependencies: []
        ),
        .target(
            name: "secp256k1",
            dependencies: []
        ),
        .target(
            name: "VIZ",
            dependencies: ["Crypto", "AnyCodable", "OrderedDictionary", "secp256k1"]
        ),
        .testTarget(
            name: "UnitTests",
            dependencies: ["VIZ"]
        ),
        .testTarget(
            name: "IntegrationTests",
            dependencies: ["VIZ"]
        ),
    ]
)
