// swift-tools-version: 5.9
import PackageDescription

#if canImport(Darwin)
let radare2Target: Target = .binaryTarget(
    name: "Radare2",
    url: "https://build.frida.re/Radare2.xcframework.zip",
    checksum: "4bd5ca96a52ab3313b249bdfcf0d6f11bce81713fd9f106aaa24894ba97c1a4d"
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
