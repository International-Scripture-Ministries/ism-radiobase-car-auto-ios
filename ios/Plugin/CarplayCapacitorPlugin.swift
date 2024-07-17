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
    
    // MARK: Carplay Related functions

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
    
    // MARK: App Related functions
    
    @objc func play(_ call: CAPPluginCall) {
        
        guard let mediaUrlString = call.getString("url") else {
            call.reject("url key-value is missing in request")
            return
        }
        
        //  Save the call. Doc: https://capacitorjs.com/docs/core-apis/saving-calls
        call.keepAlive = true
        
        //  Play the item
        let tmpPlayerItem = TMTPlayerItem(
            url: mediaUrlString,
            title: call.getString("title") ?? "",
            artist: call.getString("artist") ?? "",
            image: call.getString("image") ?? ""
        )
        
        CarPlayHelper.shared.play(item: tmpPlayerItem) {
            //  handle avplayer did finish playing
            call.resolve([
                "playerDidFinishPlayingItem": mediaUrlString
            ])
        }
    }
    
    @objc func pause(_ call: CAPPluginCall) {
        
        CarPlayHelper.shared.pause()
        
        call.resolve([
            "playerPaused": "true"
        ])
    }
    
    @objc func getCurrentPlayerItemSeekTime(_ call: CAPPluginCall) {
        
        let currentTimeInSeconds = CarPlayHelper.shared.getCurrentPlayerItemSeekTime()
        
        call.resolve([
            "currentTimeInSeconds": "\(currentTimeInSeconds)"
        ])
    }
}
