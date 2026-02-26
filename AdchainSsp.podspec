Pod::Spec.new do |spec|
  spec.name         = "AdchainSsp"
  spec.version      = "0.3.0"
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
  spec.default_subspecs = "Core"

  spec.subspec "Core" do |core|
    core.vendored_frameworks = "AdchainSsp.xcframework"
    core.dependency "AdchainCommon", "~> 0.2"
    core.frameworks = "Foundation", "UIKit"
    core.pod_target_xcconfig = {
      "SWIFT_VERSION" => "5.5",
      "ENABLE_BITCODE" => "NO"
    }
  end

  spec.subspec "Admob" do |admob|
    admob.dependency "AdchainSsp/Core"
    # Google-Mobile-Ads-SDK는 소비자가 직접 추가 (AdPopcorn 패턴)
    # pod 'Google-Mobile-Ads-SDK', '~> 12.12'
    admob.source_files = "Adapters/Admob/**/*.swift"
  end
end
