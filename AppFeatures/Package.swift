// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AppFeatures",
    defaultLocalization: "ja",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppFeatures",
            targets: ["API", "Repositories", "Extensions", "Util", "Resources", "ViewModel", "Screen"]
        ),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", .upToNextMajor(from: "5.6.1")),
        .package(url: "https://github.com/CombineCommunity/CombineCocoa.git", from: "0.2.1"),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "7.0.0")),
        .package(url: "https://github.com/keitaoouchi/MarkdownView.git", .upToNextMajor(from: "1.9.1"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AppFeatures",
            dependencies: []
        ),
        .target(
            name: "API",
            dependencies: [.product(name: "Alamofire", package: "Alamofire")],
            path: "Sources/API"
        ),
        .target(
            name: "Repositories",
            dependencies: [.target(name: "API")],
            path: "Sources/Repositories"
        ),
        .target(
            name: "Extensions",
            path: "Sources/Extensions"
        ),
        .target(
            name: "Util",
            dependencies: [.target(name: "Extensions"), .target(name: "Resources")],
            path: "Sources/Util"
        ),
        .target(
            name: "ViewModel",
            dependencies: [
                .target(name: "Repositories"),
                .target(name: "API"),
                .target(name: "Resources")
            ]
        ),
        .target(
            name: "Screen",
            dependencies: [
                .target(name: "ViewModel"),
                .target(name: "API"),
                .target(name: "Resources"),
                .product(name: "CombineCocoa", package: "CombineCocoa"),
                .product(name: "Kingfisher", package: "Kingfisher"),
                .product(name: "MarkdownView", package: "MarkdownView")
            ],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "StoryboardGenPlugin")]
        ),
        .target(
            name: "Resources",
            dependencies: [],
            resources: [.process("Resources")],
            plugins: [.plugin(name: "SwiftGenPlugin")]
        ),

        // MARK: SwiftGen

        .binaryTarget(
            name: "swift-cli-tools",
            url: "https://github.com/shimastripe/SwiftPM-Artifact-Bundle/releases/download/0.2.1/swift-cli-tools.artifactbundle.zip",
            checksum: "f8a9d286b891ba8981ddd9cb1a7ceaa45e9385976b310d49ef62bdc05a704e0c"
        ),
        .plugin(
            name: "SwiftGenPlugin",
            capability: .buildTool(),
            dependencies: ["swift-cli-tools"]
        ),
        .plugin(
            name: "StoryboardGenPlugin",
            capability: .buildTool(),
            dependencies: ["swift-cli-tools"]
        ),

        // MARK: Test

        .testTarget(
            name: "AppFeaturesTests",
            dependencies: ["AppFeatures"]
        ),
    ]
)
