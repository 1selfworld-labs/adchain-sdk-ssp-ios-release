# AdChain SSP iOS SDK

AdChain SSP iOS SDK 바이너리 배포 레포지토리입니다.

## 설치

### Swift Package Manager

**AdMob 사용 시:**
```swift
.package(url: "https://github.com/1selfworld-labs/adchain-sdk-ssp-ios-release.git", from: "0.3.0")

// Target dependency:
.product(name: "AdchainSspAdmob", package: "adchain-sdk-ssp-ios-release")
```

**Core만 사용 시 (다른 어댑터):**
```swift
.product(name: "AdchainSsp", package: "adchain-sdk-ssp-ios-release")
```

### CocoaPods

```ruby
# AdMob 포함
pod 'AdchainSsp/Admob'

# Core only
pod 'AdchainSsp'
```

> AdMob SDK(`Google-Mobile-Ads-SDK`)는 `AdchainSsp/Admob` 서브스펙이 자동으로 가져옵니다.
> 어댑터를 추가하면 `AdchainSsp.initialize()` 시 자동 감지됩니다.

## 의존성

- `AdchainCommon` 0.2.0+ (자동 설치)
- `GoogleMobileAds` 12.12.0 (`AdchainSspAdmob` / `Admob` 서브스펙 사용 시)

## 사용법

```swift
import AdchainSsp

// 초기화 (어댑터 자동 감지)
AdchainSsp.initialize(["appKey": "YOUR_APP_KEY", "isDebug": false])

// Rewarded Video 로드
let callback = MyAdCallback()
AdchainSsp.loadRewardedVideo("YOUR_PLACEMENT_ID", callback: callback)

// Rewarded Video 노출
AdchainSsp.showRewardedVideo(viewController, placementId: "YOUR_PLACEMENT_ID", callback: callback)
```

> 이 레포는 바이너리 배포용입니다. 소스는 별도 관리됩니다.
