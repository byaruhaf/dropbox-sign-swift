// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

//let package = Package(
//    name: "dropbox-sign-swift",
//    targets: [
//        // Targets are the basic building blocks of a package, defining a module or a test suite.
//        // Targets can depend on other targets in this package and products from dependencies.
//        .executableTarget(
//            name: "dropbox-sign-swift"),
//    ]
//)


let package = Package(
    name: "dropbox-sign-swift",
    platforms: [
        .macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6),
    ],
    dependencies: [
        .package(url: "https://github.com/byaruhaf/swift-openapi-generator", branch: "main"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/apple/swift-openapi-urlsession", .upToNextMinor(from: "0.2.0")),
    ],
    targets: [
        .executableTarget(
            name: "dropbox-sign-swift",
            dependencies: [
                .product(
                    name: "OpenAPIRuntime",
                    package: "swift-openapi-runtime"
                ),
                .product(
                    name: "OpenAPIURLSession",
                    package: "swift-openapi-urlsession"
                ),
            ],
            path: "Sources",
            plugins: [
                .plugin(
                    name: "OpenAPIGenerator",
                    package: "swift-openapi-generator"
                )
            ]
        )
    ]
)
