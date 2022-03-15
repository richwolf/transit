// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "Transit",
  products: [
    .library(name: "Transit", targets: ["Transit"])
  ],
  targets: [
    .target(
      name: "Transit",
      resources: []
		),
    .testTarget(
      name: "TransitTests",
      dependencies: ["Transit"],
      resources: [.process("Test Data")]
		)
  ]
)
