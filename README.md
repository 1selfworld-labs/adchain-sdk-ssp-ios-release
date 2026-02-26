# AdChain SSP iOS SDK

AdChain SSP iOS SDK 바이너리 배포 레포지토리입니다.

## 설치 (Swift Package Manager)

Xcode > File > Add Package Dependencies에서 아래 URL을 추가:

```
https://github.com/1selfworld-labs/adchain-sdk-ssp-ios-release.git
```

또는 `Package.swift`:

```swift
.package(url: "https://github.com/1selfworld-labs/adchain-sdk-ssp-ios-release.git", from: "0.2.0")
```

## 의존성 (자동 설치)
- `AdchainCommon` 0.2.0+
- `GoogleMobileAds` 12.12.0

## 사용법

```swift
import AdchainSsp

// 초기화
AdchainSsp.initialize(["appKey": "YOUR_APP_KEY", "isDebug": false])

// Rewarded Video 로드
let callback = MyAdCallback()
AdchainSsp.loadRewardedVideo("YOUR_PLACEMENT_ID", callback: callback)

// Rewarded Video 노출
AdchainSsp.showRewardedVideo(viewController, placementId: "YOUR_PLACEMENT_ID", callback: callback)
```

> 이 레포는 바이너리 배포용입니다. 소스는 별도 관리됩니다.
