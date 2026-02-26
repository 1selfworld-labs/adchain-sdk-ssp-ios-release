# AdChain SSP iOS SDK

AdChain SSP iOS SDK 바이너리 배포 레포지토리입니다.

## 설치

### Swift Package Manager

**AdMob 사용 시:**
```swift
.package(url: "https://github.com/1selfworld-labs/adchain-sdk-ssp-ios-release.git", from: "0.3.2")

// Target dependency:
.product(name: "AdchainSspAdmob", package: "adchain-sdk-ssp-ios-release")
```

**Core만 사용 시 (다른 어댑터):**
```swift
.product(name: "AdchainSsp", package: "adchain-sdk-ssp-ios-release")
```

### CocoaPods

**Core only:**
```ruby
pod 'AdchainSsp'
```

**AdMob 함께 사용 시:**
1. [GitHub Releases](https://github.com/1selfworld-labs/adchain-sdk-ssp-ios-release/releases/latest)에서 `AdchainSspAdmob-X.X.X.zip` 다운로드
2. `AdmobAdapter.swift`, `AdmobAdapterFactory.swift`를 프로젝트에 추가
3. Podfile에 추가:
```ruby
pod 'AdchainSsp'
pod 'Google-Mobile-Ads-SDK', '~> 12.12'
```

> 어댑터 파일을 추가하면 `AdchainSspSDK.initialize()` 시 자동 감지됩니다.

## 의존성

- `AdchainCommon` 0.2.0+ (자동 설치)
- `GoogleMobileAds` 12.12.0 (`AdchainSspAdmob` SPM 제품 사용 시 자동 포함)

## 사용법

```swift
import AdchainSsp

// 초기화 (어댑터 자동 감지)
AdchainSspSDK.initialize(["appKey": "YOUR_APP_KEY", "isDebug": false])

// Rewarded Video 로드
let callback = MyAdCallback()
AdchainSspSDK.loadRewardedVideo("YOUR_PLACEMENT_ID", callback: callback)

// Rewarded Video 노출
AdchainSspSDK.showRewardedVideo(viewController, placementId: "YOUR_PLACEMENT_ID", callback: callback)
```

> 이 레포는 바이너리 배포용입니다. 소스는 별도 관리됩니다.
