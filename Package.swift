// swift-tools-version: 5.9
import PackageDescription

#if canImport(Darwin)
let radare2Target: Target = .binaryTarget(
    name: "Radare2",
    url: "https://build.frida.re/Radare2-20260419-82c27d6.xcframework.zip",
    checksum: "d2970ab5ac88d70fa193265a16618abbb756d96b4ad33e34a1b87de3608b11d4"
)
#else
let radare2Target: Target = .systemLibrary(
    name: "Radare2",
    pkgConfig: "r_core",
    providers: [
        .apt(["libradare2-dev"]),
        .brew(["radare2"]),
    ]
)
#endif

let package = Package(
    name: "SwiftyR2",
    platforms: [
        .macOS(.v11),
        .iOS(.v13),
    ],
    products: [
        .library(
            name: "SwiftyR2",
            targets: ["SwiftyR2"]
        )
    ],
    targets: [
        radare2Target,

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
