// swift-tools-version: 6.0

import PackageDescription

let package = Package(
  name: "MessagePack",
  products: [
    .library(
      name: "MessagePack",
      targets: ["MessagePack"]
    ),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-numerics", from: "1.0.2"),
  ],
  targets: [
    .target(
      name: "MessagePack",
      dependencies: []
    ),
    .testTarget(
      name: "MessagePackTests",
      dependencies: [
        "MessagePack",
        .product(name: "Numerics", package: "swift-numerics"),
      ]
    ),
  ]
)
