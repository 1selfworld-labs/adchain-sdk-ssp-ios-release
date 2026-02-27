import Foundation
import AdchainSspCore
import GoogleMobileAds

@objc(AdchainAdmobFactory)
public class AdmobAdapterFactory: NSObject, SspAdapterFactory {
    public func createAdapter(config: [String: Any]) -> SspAdapter? {
        guard NSClassFromString("GADMobileAds") != nil else {
            return nil
        }
        MobileAds.shared.start(completionHandler: nil)
        return AdmobAdapter(config: config)
    }
}
