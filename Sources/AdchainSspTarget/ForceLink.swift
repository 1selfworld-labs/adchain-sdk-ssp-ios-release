import Foundation
import AdchainSspCore

// AdchainSsp 클래스를 linker가 strip하지 않도록 강제 참조.
// Core SDK(adchain-sdk-ios)의 SspBridge가
// NSClassFromString("AdchainSspCore.AdchainSsp")로 런타임 감지하는데,
// static library에서는 컴파일 타임 참조 없으면 strip됨.
// @objc 클래스는 ObjC 런타임에 등록되므로 컴파일러가 제거 불가.
@objc
private class _AdchainSspForceLink: NSObject {
    @objc static let _class: AnyClass = AdchainSspCore.AdchainSsp.self
}
