// swift-tools-version:5.2

import PackageDescription

let package = Package(
  name: "MessagePack",
  products: [
    .library(
      name: "MessagePack",
      targets: ["MessagePack"]
    ),
  ],
  targets: [
    .target(
      name: "MessagePack",
      dependencies: []
    ),
    .testTarget(
      name: "MessagePackTests",
      dependencies: ["MessagePack"]
    ),
  ]
)
