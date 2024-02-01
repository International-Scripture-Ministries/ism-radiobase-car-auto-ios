//
//  CarPlayHelper.swift
//  CarPlayDemo
//
//  Created by fahid on 01/12/2022.
//

import Foundation
import CarPlay
import AVFoundation
import AVKit
import MediaPlayer
import Alamofire


@objc public class CarPlayHelper: NSObject {
    @objc public static let shared = CarPlayHelper()
    @objc public var isCarplayConnected: Bool = false
    var player = AVPlayer()
    var timer: Timer?
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    @objc public func startStreaming() {
        let playerItem = AVPlayerItem(url: URL(string: "https://s3.radio.co/s2781af807/listen")!)
        player = AVPlayer(playerItem: playerItem)
        player.rate = 1.0
        player.play()
        setupRemoteCommandCenterTargets()
        //  First time fetch metadata righ away and then schedule using timer
        checkForMetaData()
        timer = Timer.scheduledTimer(timeInterval: 10,
                                     target: self,
                                     selector: #selector(checkForMetaData),
                                     userInfo: nil,
                                     repeats: true)
    }
    
    @objc private func checkForMetaData() {
            Alamofire.request("https://public.radio.co/stations/s2781af807/status").responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    guard let json = value as? [String:Any] else { return }
                    print(json)
                    guard let currentTrack = json["current_track"] as? [String:Any] else { return }
                    print(currentTrack)
                    guard let title = currentTrack["title"] as? String else { return }
                    guard let image = currentTrack["artwork_url_large"] as? String else { return }
                    debugPrint(value)
                    self.setPlayerNowPlayingInformation(title: title, image: image, artist: "")
                case .failure(let error):
                    debugPrint(error)
                }
            }
        }
    
    private func setPlayerNowPlayingInformation(title: String, image: String, artist: String) {
        
        var nowPlayingInfo = [String: Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = title
        nowPlayingInfo[MPMediaItemPropertyArtist] = artist
        
        if image.isEmpty {
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
            return
        }
        
        DispatchQueue.global().async {
            if let url = URL(string: image) {
                if let data = try? Data(contentsOf: url), let image = UIImage(data: data) {
                    let artwork = MPMediaItemArtwork(boundsSize: image.size, requestHandler: { (_ size : CGSize) -> UIImage in
                        return image
                    })
                    nowPlayingInfo[MPMediaItemPropertyArtwork] = artwork
                    
                    DispatchQueue.main.async {
                        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
                    }
                }
            }
        }
    }
    
    private func setupRemoteCommandCenterTargets() {
        
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(playStreaming))
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(pauseStreaming))
        
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false
    }
    
    @objc public func playStreaming() -> MPRemoteCommandHandlerStatus {
        self.player.play()
        return MPRemoteCommandHandlerStatus.success
    }
    
    @objc public func pauseStreaming() -> MPRemoteCommandHandlerStatus {
        self.pausePlayer()
        return MPRemoteCommandHandlerStatus.success
    }
    
    @objc func pausePlayer() {
        self.player.pause()
    }
}
