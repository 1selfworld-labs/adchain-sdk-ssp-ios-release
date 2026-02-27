# AdChain SSP iOS SDK - 배포 레포 가이드

`adchain-sdk-ssp-ios-release`는 AdchainSsp SDK의 **바이너리 배포 레포**입니다.
XCFramework + 어댑터 소스를 함께 제공하며 SPM과 CocoaPods를 통해 배포됩니다.

---

## 배포 완료 체크리스트

릴리스 시 아래 항목을 **모두** 완료해야 합니다. 하나라도 빠지면 배포 미완료입니다.

- [ ] `AdchainSspCore.xcframework` 교체 (Google 심볼 0개 확인)
- [ ] `Adapters/Admob/` 소스 파일 업데이트
- [ ] `Package.swift` 버전/의존성 확인
- [ ] `AdchainSsp.podspec` 버전 업데이트 + `pod trunk push` (→ CocoaPods 배포 완료)
- [ ] `git tag -a "vX.X.X"` + push (→ SPM 배포 완료)
- [ ] GitHub Release: `gh release create vX.X.X` + `AdchainSspAdmob-X.X.X.zip` 첨부
- [ ] 소스 레포 태그 1:1 매칭 확인
- [ ] README.md 버전 업데이트 (설치 가이드 버전 확인)
- [ ] downstream 레포 의존성 업데이트 (Package.swift from: 버전)

---

## 레포 구조

```
adchain-sdk-ssp-ios-release/
├── AdchainSspCore.xcframework/    # Core 바이너리 (Google 없음)
│   ├── ios-arm64/                 # Device slice
│   └── ios-arm64_x86_64-simulator/ # Simulator slice
├── Adapters/
│   └── Admob/
│       ├── AdmobAdapter.swift     # SPM AdchainSspAdmob 타겟 소스
│       └── AdmobAdapterFactory.swift
├── Sources/
│   └── AdchainSspTarget/
│       └── ForceLink.swift        # @objc ForceLink: AdchainSsp 링커 스트리핑 방지
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

`AdchainSspAdmob`을 추가하면 `AdchainSspCore` 바이너리와 `GoogleMobileAds 12.12.0`이 함께 설치됩니다.

### Core만 사용 (다른 어댑터 직접 구현 시)

```swift
.product(name: "AdchainSsp", package: "adchain-sdk-ssp-ios-release")
```

### 사용법

```swift
import AdchainSspCore

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
| `AdchainSsp` | `AdchainSspTarget` → `AdchainSspCore` | Core XCFramework + AdchainCommon |
| `AdchainSspAdmob` | `AdchainSspAdmob` | AdmobAdapter 소스 + GoogleMobileAds 12.12.0 |

### 의존성 체인

```
AdchainSspAdmob (source)
  ├── AdchainSspTarget (wrapper, ForceLink)
  │     ├── AdchainSspCore (xcframework binary)
  │     └── AdchainCommon (xcframework binary)
  └── GoogleMobileAds 12.12.0
```

---

## 릴리스 업데이트 절차

이 레포의 파일을 직접 수정하지 마세요. 배포 절차는 **소스 레포의 DEPLOYMENT_GUIDE.md**를 참조하세요.

```
adchain-sdk-ssp-ios/DEPLOYMENT_GUIDE.md
```

---

## 현재 버전 정보

| 항목 | 값 |
|------|-----|
| 최신 버전 | 0.3.7 |
| XCFramework | Core only (Google 없음), 모듈명: AdchainSspCore |
| CocoaPods | `AdchainSsp` 0.3.7 |
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
