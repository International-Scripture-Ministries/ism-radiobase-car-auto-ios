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
import UIKit
import AVKit
import Combine
import MediaPlayer

// MARK: TMTPlayer Item

@objc public class TMTPlayerItem: NSObject {
    
    var url: String
    var title: String
    var artist: String
    var image: String
    
    public init(url: String, title: String, artist: String, image: String) {
        self.url = url
        self.title = title
        self.artist = artist
        self.image = image
    }
}

// MARK: Carplay Helper

@objc public class CarPlayHelper: NSObject {
    
    // MARK: Static Properties
    
    @objc static let shared = CarPlayHelper()
    
    // MARK: Initialization
    
    private override init() {
        super.init()
        try? AVAudioSession.sharedInstance().setCategory(.playback)
        try? AVAudioSession.sharedInstance().setActive(true)
        self.handlePlayerDidEndPlayingObserver()
    }
    
    deinit {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK: Public Properties
    
    @objc var isCarplayConnected: Bool = false
    
    // MARK: Private Properties
    
    //  Carplay
    private let url = "https://devmanage.radiobase.org/index.php?api_v2/Builder/RadioPlayer/getRadioPlayer/1167"
    private var apiIntervalSeconds = 10.0
    private var isPlayerItemConfigured = false
    private var timer: Timer?
    
    //  App
    private let skipInterval = NSNumber(integerLiteral: 15)
    private var avPlayer = AVPlayer()
    private var cancellables: Set<AnyCancellable> = []
    private var avPlayerDidEndPlaying: (() -> Void)?
}

// MARK: For Carplay Player

@objc public extension CarPlayHelper {
    
    // MARK: Public Functions
    
    @objc func startStreaming() {
        
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
                            self.avPlayer = AVPlayer(playerItem: playerItem)
                            self.avPlayer.rate = 1.0
                            self.avPlayer.play()
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
    
    @objc func playStreaming() -> MPRemoteCommandHandlerStatus {
        self.avPlayer.play()
        return MPRemoteCommandHandlerStatus.success
    }
    
    @objc func pauseStreaming() -> MPRemoteCommandHandlerStatus {
        self.avPlayer.pause()
        return MPRemoteCommandHandlerStatus.success
    }
    
    // MARK: Private Functions
    
    private func getUrlWithEpoch() -> String {
        
        let timeInterval = Date().timeIntervalSince1970
        let epoch = String(Int(timeInterval))
        let urlWithEpch = self.url + "/" + epoch
        return urlWithEpch
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
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.playCommand.addTarget(self, action: #selector(playStreaming))
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.pauseCommand.addTarget(self, action: #selector(pauseStreaming))
        
        commandCenter.nextTrackCommand.isEnabled = false
        commandCenter.previousTrackCommand.isEnabled = false
        commandCenter.skipForwardCommand.isEnabled = false
        commandCenter.skipBackwardCommand.isEnabled = false
        commandCenter.changePlaybackPositionCommand.isEnabled = false
    }
}

// MARK: For App Player

@objc public extension CarPlayHelper {
    
    //  MARK: Public Methods
    
    func play(item: TMTPlayerItem, avPlayerDidEndPlaying: @escaping (() -> Void)) {
        
        guard let url = URL(string: item.url) else {
            return
        }
        
        self.avPlayerDidEndPlaying = avPlayerDidEndPlaying
        let avPlayerItem = AVPlayerItem(url: url)
        self.avPlayer.replaceCurrentItem(with: avPlayerItem)
        self.avPlayer.play()
        self.setupRemoteCommandCenter()
        self.setupNowPlaying(avPlayerItem: avPlayerItem, tmtPlayerItem: item)
    }
    
    func pause() {
        
        self.avPlayer.pause()
    }
    
    func getCurrentPlayerItemSeekTime() -> Double {
        
        return self.avPlayer.currentTime().seconds
    }
    
    //  MARK: Private Methods
    
    private func handlePlayerDidEndPlayingObserver() {
        
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.avPlayer.seek(to: CMTime.zero)
                self?.avPlayerDidEndPlaying?()
            }
            .store(in: &cancellables)
    }
    
    private func setupNowPlaying(avPlayerItem: AVPlayerItem, tmtPlayerItem: TMTPlayerItem) {
        
        // Define Now Playing Info
        var nowPlayingInfo = [String : Any]()
        nowPlayingInfo[MPMediaItemPropertyTitle] = tmtPlayerItem.title
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = avPlayerItem.currentTime().seconds
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = avPlayerItem.asset.duration.seconds
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = self.avPlayer.rate
        
        if tmtPlayerItem.image.isEmpty {
            // Set the metadata
            MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
        } else {
            
            DispatchQueue.global().async {
                if let url = URL(string: tmtPlayerItem.image) {
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
        
        MPNowPlayingInfoCenter.default().playbackState = .playing
    }
    
    private func setupRemoteCommandCenter() {
        
        let commandCenter = MPRemoteCommandCenter.shared();
        
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.removeTarget(nil)
        commandCenter.playCommand.addTarget { [weak self] event in
            self?.avPlayer.play()
            return .success
        }
        
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.removeTarget(nil)
        commandCenter.pauseCommand.addTarget { [weak self] event in
            self?.avPlayer.pause()
            return .success
        }
        
        commandCenter.skipForwardCommand.isEnabled = true
        commandCenter.skipForwardCommand.preferredIntervals = [self.skipInterval]
        commandCenter.skipForwardCommand.removeTarget(nil)
        commandCenter.skipForwardCommand.addTarget { event in
            guard let _ = event.command as? MPSkipIntervalCommand else {
                return .noSuchContent
            }
            return .success
        }
        
        commandCenter.skipBackwardCommand.isEnabled = true
        commandCenter.skipBackwardCommand.preferredIntervals = [self.skipInterval]
        commandCenter.skipBackwardCommand.removeTarget(nil)
        commandCenter.skipBackwardCommand.addTarget { event in
            guard let _ = event.command as? MPSkipIntervalCommand else {
                return .noSuchContent
            }
            return .success
        }
        
        /*
         commandCenter.nextTrackCommand.isEnabled = true
         commandCenter.nextTrackCommand.addTarget { [weak self] event in
         self?.avPlayer.pause()
         self?.startNextMediaItem()
         return .success
         }
         
         commandCenter.previousTrackCommand.isEnabled = true
         commandCenter.previousTrackCommand.addTarget { [weak self] event in
         self?.avPlayer.pause()
         self?.startNextMediaItem()
         return .success
         }
         */
        
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.removeTarget(nil)
        commandCenter.changePlaybackPositionCommand.addTarget { [weak self] event in
            
            guard let self else {
                return .commandFailed
            }
            
            let playerRate = self.avPlayer.rate
            if let event = event as? MPChangePlaybackPositionCommandEvent {
                let seekToTime = CMTime(seconds: event.positionTime, preferredTimescale: CMTimeScale(1000))
                self.avPlayer.seek(to: seekToTime) { [weak self] success in
                    if success {
                        self?.avPlayer.rate = playerRate
                    }
                }
                return .success
            }
            
            return .commandFailed
        }
    }
}
