// swift-tools-version:5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.
// Use macOS V12.

import PackageDescription

let package = Package(
    name: "DDSCommon",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(name: "DDSCommon", targets: ["DDSCommon"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
      .package(url: "https://github.com/weichsel/ZIPFoundation.git", .upToNextMajor(from: "0.9.0")),
      .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(name: "DDSCommon",
                dependencies: [
                  "ZIPFoundation",
                  .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                  .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                ],
                path: "Sources"),
        .testTarget( name: "DDSCommonTests", dependencies: ["DDSCommon"]),
        //        .binaryTarget(name: "Sparkle", path: "artifacts/")
    ]
)
