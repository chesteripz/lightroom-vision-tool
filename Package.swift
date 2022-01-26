// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "lightroom-core-ml-cli",
  platforms: [
    .macOS(.v12)
  ],
  products: [
    .executable(name: "lightroom-core-ml-cli", targets: ["lightroom-core-ml-cli"])
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(
      url: "https://github.com/apple/swift-argument-parser",
      from: "0.0.1")
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .executableTarget(
      name: "lightroom-core-ml-cli",
      dependencies: [
        .product(name: "ArgumentParser", package: "swift-argument-parser")
      ]),
    .testTarget(
      name: "lightroom-core-ml-cliTests",
      dependencies: ["lightroom-core-ml-cli"]),
  ]
)
