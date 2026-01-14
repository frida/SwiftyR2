// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "Example",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
    ],
    dependencies: [
        .package(path: "../")
    ],
    targets: [
        .executableTarget(
            name: "Hello",
            dependencies: ["SwiftyR2"]
        ),
    ]
)