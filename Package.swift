// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftyR2",
    platforms: [
        .macOS(.v11),
        .iOS(.v12),
    ],
    products: [
        .library(
            name: "SwiftyR2",
            targets: ["SwiftyR2"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Radare2",
            url: "https://build.frida.re/Radare2.xcframework.zip",
            checksum: "27f41fab7c82601e688c73808477bc2f277a0c126b4adfea6ef8204888bdb14e"
        ),

        .target(
            name: "SwiftyR2",
            dependencies: ["Radare2"]
        ),

        .testTarget(
            name: "SwiftyR2Tests",
            dependencies: ["SwiftyR2"]
        ),
    ]
)
