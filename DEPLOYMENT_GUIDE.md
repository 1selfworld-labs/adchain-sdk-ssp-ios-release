# AdChain SSP iOS SDK - 배포 레포 가이드

`adchain-sdk-ssp-ios-release`는 AdchainSsp SDK의 **바이너리 배포 레포**입니다.
XCFramework + 어댑터 소스를 함께 제공하며 SPM과 CocoaPods를 통해 배포됩니다.

---

## 레포 구조

```
adchain-sdk-ssp-ios-release/
├── AdchainSsp.xcframework/        # Core 바이너리 (Google 없음)
│   ├── ios-arm64/                 # Device slice
│   └── ios-arm64_x86_64-simulator/ # Simulator slice
├── Adapters/
│   └── Admob/
│       ├── AdmobAdapter.swift     # SPM AdchainSspAdmob 타겟 소스
│       └── AdmobAdapterFactory.swift
├── Sources/
│   └── Wrapper/
│       └── exports.swift          # @_exported import re-export
├── Package.swift                  # SPM 패키지 정의
├── AdchainSsp.podspec             # CocoaPods spec (Core only)
└── LICENSE
```

---

## SPM 설치 가이드 (소비자용)

### AdMob 어댑터 포함 (권장)

```swift
// Package.swift
dependencies: [
    .package(url: "https://github.com/1selfworld-labs/adchain-sdk-ssp-ios-release.git", from: "0.3.0"),
],
targets: [
    .target(
        name: "YourApp",
        dependencies: [
            .product(name: "AdchainSspAdmob", package: "adchain-sdk-ssp-ios-release"),
        ]
    ),
]
```

`AdchainSspAdmob`을 추가하면 `AdchainSsp` 코어와 `GoogleMobileAds 12.12.0`이 함께 설치됩니다.

### Core만 사용 (다른 어댑터 직접 구현 시)

```swift
.product(name: "AdchainSsp", package: "adchain-sdk-ssp-ios-release")
```

### 사용법

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

> `AdchainSspAdmob`이 링크된 경우 `initialize()` 시 AdMob 어댑터가 자동 감지됩니다.
> 별도의 `registerAdapter()` 호출 없이 자동으로 동작합니다.

---

## CocoaPods 설치 가이드 (소비자용)

```ruby
# Podfile
pod 'AdchainSsp'  # Core only

# AdMob은 별도로 추가 (SPM 사용 권장)
# pod 'Google-Mobile-Ads-SDK'  # 필요시
```

> **주의**: CocoaPods는 Core만 제공합니다. AdMob 어댑터는 **SPM `AdchainSspAdmob`** 으로 설치하세요.

---

## SPM 패키지 구조

| Product | 타겟 | 포함 내용 |
|---------|------|---------|
| `AdchainSsp` | `AdchainSspWrapper` → `AdchainSspBinary` | Core XCFramework + AdchainCommon |
| `AdchainSspAdmob` | `AdchainSspAdmob` | AdmobAdapter 소스 + GoogleMobileAds 12.12.0 |

### 의존성 체인

```
AdchainSspAdmob (source)
  ├── AdchainSspWrapper (re-export)
  │     ├── AdchainSspBinary (xcframework binary)
  │     └── AdchainCommon (xcframework binary)
  └── GoogleMobileAds 12.12.0
```

---

## 릴리스 업데이트 절차

이 레포의 파일을 직접 수정하지 마세요. 배포 절차는 **소스 레포의 DEPLOYMENT_GUIDE.md**를 참조하세요.

```
adchain-sdk-ssp-ios/DEPLOYMENT_GUIDE.md
```

### 빠른 참조: 릴리스 체크리스트

- [ ] `AdchainSsp.xcframework` 교체 (Google 심볼 0개 확인)
- [ ] `Adapters/Admob/` 소스 파일 업데이트
- [ ] `Package.swift` 버전/의존성 확인
- [ ] `AdchainSsp.podspec` 버전 업데이트
- [ ] `git tag -a "vX.X.X"` + push
- [ ] `pod trunk push AdchainSsp.podspec --allow-warnings`

---

## 현재 버전 정보

| 항목 | 값 |
|------|-----|
| 최신 버전 | 0.3.0 |
| XCFramework | Core only (Google 없음) |
| CocoaPods | `AdchainSsp` 0.3.0 |
| SPM | `AdchainSsp` + `AdchainSspAdmob` |
| AdchainCommon 의존성 | `~> 0.2` |
| GoogleMobileAds (Admob) | `exact: "12.12.0"` |
| 최소 iOS | 14.0 |

---

## 트러블슈팅

### SPM fingerprint 오류

```bash
rm -rf ~/Library/Caches/org.swift.swiftpm
rm -rf .build/
```

### CocoaPods 검색에 새 버전이 안 보임

```bash
pod repo update
pod search AdchainSsp
```

### GoogleMobileAds 버전 충돌

`Package.swift`에서 `exact: "12.12.0"` 고정 확인.
앱의 다른 Google 의존성과 버전이 다를 경우 SPM이 충돌을 보고합니다.
소스 레포(`adchain-sdk-ssp-ios/Adapters/Admob/`)와 호환성 확인 후 버전 업데이트.
