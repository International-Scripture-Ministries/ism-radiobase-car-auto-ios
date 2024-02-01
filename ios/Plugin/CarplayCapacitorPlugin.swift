import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CarplayCapacitorPlugin)
public class CarplayCapacitorPlugin: CAPPlugin {

    @objc public func startStreamingCarPlay(_ call: CAPPluginCall) {
        CarPlayHelper.shared.startStreaming()
        call.resolve()
    }
    
    @objc public func playStreamingCarPlay(_ call: CAPPluginCall) {
        _ = CarPlayHelper.shared.playStreaming()
        call.resolve()
    }
    
    @objc public func pauseStreamingCarPlay(_ call: CAPPluginCall) {
        _ = CarPlayHelper.shared.pauseStreaming()
        call.resolve()
    }
    
    @objc public func isCarplayConnected(_ call: CAPPluginCall) {
        let message = CarPlayHelper.shared.isCarplayConnected ? "1" : "0"
        call.resolve(["result": message])
    }
}
