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
    private let url = "https://devmanage.radiobase.org/index.php?api_v2/Builder/RadioPlayer/getRadioPlayer/1167"
    private var apiIntervalSeconds = 10.0
    private var isPlayerItemConfigured = false

    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    private func getUrlWithEpoch() -> String {
        
        let timeInterval = Date().timeIntervalSince1970
        let epoch = String(Int(timeInterval))
        let urlWithEpch = self.url + "/" + epoch
        return urlWithEpch
    }
    
    @objc public func startStreaming() {
        
        //  fetch audio info using api
        //  https://devmanage.radiobase.org/index.php?api_v2/Builder/RadioPlayer/getRadioPlayer/1167
        
        let url = self.getUrlWithEpoch()
        Alamofire.request(url)
            .responseJSON { [weak self] dataResponse in
                guard let self else { return }
                switch dataResponse.result {
                case .success(let value):
                    guard let json = value as? [String:Any] else { return }
                    if let isLiveStream = json["radio_player_live_Stream"] as? Bool {
                        
                        print("-----------")
                        print("isLiveStream: \(isLiveStream)")
//                        self.apiIntervalSeconds = isLiveStream ? 3.0 : 10.0
                        self.apiIntervalSeconds = 10.0
                        self.timer?.invalidate()
                        self.timer = Timer.scheduledTimer(
                            timeInterval: self.apiIntervalSeconds,
                            target: self,
                            selector: #selector(self.startStreaming),
                            userInfo: nil,
                            repeats: true
                        )
                    }
                    
                    guard let musicArray = json["music"] as? [[String:Any]] else { return }
                    guard let music = musicArray.first else { return }
                    
                    if !self.isPlayerItemConfigured {
                        //  Source url can not change as per requirement from backend
                        if let source = music["source"] as? String,
                           let url = URL(string: source) {
                            print("Source: \(source)")
                            
                            self.isPlayerItemConfigured = true

                            //  Configure player item
                            
                            let playerItem = AVPlayerItem(url: url)
                            self.player = AVPlayer(playerItem: playerItem)
                            self.player.rate = 1.0
                            self.player.play()
                            self.setupRemoteCommandCenterTargets()
                        }
                    }
                    
                    //  Setup now playing info
                    
                    var npTitle = ""
                    var npImage = ""
                    var npArtist = ""
                    if let title = music["title"] as? String {
                        npTitle = title
                    }
                    if let image = music["image"] as? String {
                        npImage = image
                    }
                    if let artist = music["artist"] as? String {
                        npArtist = artist
                    }

                    self.setPlayerNowPlayingInformation(title: npTitle, image: npImage, artist: npArtist)

                case .failure(let error):
                    debugPrint(error)
                }
            }
    }
    
    private func setPlayerNowPlayingInformation(title: String, image: String, artist: String) {
        
        print("title: \(title)")
        print("image: \(image)")
        print("artist: \(artist)")
        
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
