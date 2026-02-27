// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "AdchainSsp",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AdchainSsp",
            targets: ["AdchainSsp"]
        ),
        .library(
            name: "AdchainSspAdmob",
            targets: ["AdchainSspAdmob"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/1selfworld-labs/adchain-sdk-common-ios-release.git",
            from: "0.2.0"
        ),
        .package(
            url: "https://github.com/googleads/swift-package-manager-google-mobile-ads.git",
            exact: "12.12.0"
        ),
    ],
    targets: [
        .binaryTarget(
            name: "AdchainSspBinary",
            path: "AdchainSsp.xcframework"
        ),
        .target(
            name: "AdchainSsp",
            dependencies: [
                "AdchainSspBinary",
                .product(name: "AdchainCommon", package: "adchain-sdk-common-ios-release"),
            ],
            path: "Sources/Wrapper"
        ),
        .target(
            name: "AdchainSspAdmob",
            dependencies: [
                "AdchainSsp",
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
            path: "Adapters/Admob"
        ),
    ]
)
