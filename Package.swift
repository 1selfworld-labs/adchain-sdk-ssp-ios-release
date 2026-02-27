// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "AdchainSsp",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AdchainSsp",
            targets: ["AdchainSspCore"]
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
            name: "AdchainSspCore",
            path: "AdchainSspCore.xcframework"
        ),
        .target(
            name: "AdchainSspAdmob",
            dependencies: [
                "AdchainSspCore",
                .product(name: "AdchainCommon", package: "adchain-sdk-common-ios-release"),
                .product(name: "GoogleMobileAds", package: "swift-package-manager-google-mobile-ads"),
            ],
            path: "Adapters/Admob"
        ),
    ]
)
