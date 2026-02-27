Pod::Spec.new do |spec|
  spec.name         = "AdchainSsp"
  spec.version      = "0.3.3"
  spec.summary      = "AdChain SSP iOS SDK - Server-Side Platform advertising"
  spec.description  = <<-DESC
                       AdChain SSP SDK providing adapter-based mediation:
                       - AdMob mediation (Rewarded Video, Interstitial)
                       - Auto-detects linked adapters at runtime
                       - Integration with AdChain Core SDK via bridge protocol
                       DESC
  spec.homepage     = "https://github.com/1selfworld-labs/adchain-sdk-ssp-ios-release"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "1selfworld-labs" => "chocosprite21@gmail.com" }
  spec.platform     = :ios, "14.0"
  spec.ios.deployment_target = "14.0"
  spec.source       = {
    :git => "https://github.com/1selfworld-labs/adchain-sdk-ssp-ios-release.git",
    :tag => "v#{spec.version}"
  }
  spec.swift_version = "5.5"
  spec.requires_arc = true

  spec.vendored_frameworks = "AdchainSsp.xcframework"
  spec.dependency "AdchainCommon", "~> 0.2"
  spec.frameworks = "Foundation", "UIKit"
  spec.pod_target_xcconfig = {
    "SWIFT_VERSION" => "5.5",
    "ENABLE_BITCODE" => "NO"
  }
end
