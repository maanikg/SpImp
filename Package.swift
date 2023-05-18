// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "SpeechImprovement",
    dependencies: [
        .package(url: "https://github.com/pvieito/PythonKit.git", from: "0.1.0"),
    ],
    targets: [
        .target(
            name: "YourProjectName",
            dependencies: [
                .product(name: "PythonKit", package: "PythonKit"),
            ]
        ),
    ]
)
