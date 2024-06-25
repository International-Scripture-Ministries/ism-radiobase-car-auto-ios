import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(CarplayCapacitorPlugin)
public class CarplayCapacitorPlugin: CAPPlugin {
    private let implementation = CarplayCapacitor()

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": implementation.echo(value)
        ])
    }
    
    @objc func startStreamingCarPlay(_ call: CAPPluginCall) {
        CarPlayHelper.shared.startStreaming()
        call.resolve()
    }
    
    @objc func playStreamingCarPlay(_ call: CAPPluginCall) {
        _ = CarPlayHelper.shared.playStreaming()
        call.resolve()
    }
    
    @objc func pauseStreamingCarPlay(_ call: CAPPluginCall) {
        _ = CarPlayHelper.shared.pauseStreaming()
        call.resolve()
    }
    
    @objc func isCarplayConnected(_ call: CAPPluginCall) {
        let message = CarPlayHelper.shared.isCarplayConnected ? "1" : "0"
        call.resolve(["result": message])
    }
}
