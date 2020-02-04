//
//  PlayerController.swift
//  RumblApp
//
//  Created by Umamaheshwari on 30/01/20.
//  Copyright © 2020 Umamaheshwari. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class PlayerController: UIViewController {

    @IBOutlet weak var buttonBackIcon: UIButton!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var viewVideoPlayer: UIView!
    var currentIndex: IndexPath?
    var playerController = AVPlayerViewController()
    var videoPlayer = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        do {
            if #available(iOS 10.0, *) {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category(rawValue: convertFromAVAudioSessionCategory(AVAudioSession.Category.playback)), mode: AVAudioSession.Mode.moviePlayback)
            } else {
                // Fallback on earlier versions
                AVAudioSession.sharedInstance().perform(NSSelectorFromString("setCategory:error:"), with: AVAudioSession.Category.playback)
            }
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        displayVideo()
    }
    
    @IBAction func handlerToDismissView(_ sender: Any) {
        defer {
            if self.playerController.player != nil {
                self.playerController.removeFromParent()
                self.playerController.player?.pause()
                self.playerController.player = nil
            }
        }
        //self.dismiss(animated: true, completion: nil)
        dismissDetail()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if self.playerController.player != nil {
            self.videoPlayer.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            //self.videoPlayer.removeObserver(self, forKeyPath: "timeControlStatus")
            self.playerController.removeFromParent()
            self.playerController.player?.pause()
            self.playerController.player = nil
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
        if videoPlayer.currentItem != nil {
            videoPlayer.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
        }
    }
    
    
    // The video content will be played with the category
    func displayVideo() {
        if self.playerController.player != nil {
            self.videoPlayer.currentItem?.removeObserver(self, forKeyPath: #keyPath(AVPlayerItem.status))
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.playerController.player?.currentItem)
            self.playerController.removeFromParent()
            self.playerController.player?.pause()
            self.playerController.player = nil
        }
        if currentIndex != nil {
            self.videoPlayer = AVPlayer(url: URL(string: moviesData[currentIndex!.section].nodes[currentIndex!.row].video.encodeUrl)!)
            self.videoPlayer.currentItem?.addObserver(self, forKeyPath: #keyPath(AVPlayerItem.status), options: .new, context: nil)
            self.playerController = AVPlayerViewController()
            self.playerController.showsPlaybackControls = true
            
            self.playerController.player?.currentItem?.preferredPeakBitRate = 0
            self.playerController.player = self.videoPlayer
            self.playerController.view.frame = self.viewVideoPlayer.bounds
            self.playerController.view.isUserInteractionEnabled = true
            self.viewVideoPlayer.addSubview(self.playerController.view)
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == #keyPath(AVPlayerItem.status) {
            let status: AVPlayerItem.Status
            
            if let statusNumber = change?[.newKey] as? NSNumber {
                status = AVPlayerItem.Status(rawValue: statusNumber.intValue)!
                DispatchQueue.main.async {[weak self] in
                    if let weakSelf = self {
                        if status.rawValue == 1 {
                            // Status rawValue 1 indicateds is readyToPlay
                            if weakSelf.playerController.player?.currentTime().seconds == 0.0 {
                                weakSelf.playerController.player?.play()
                            }
                        } else {
                            weakSelf.videoPlayer.currentItem?.removeObserver(weakSelf, forKeyPath: #keyPath(AVPlayerItem.status))
                            weakSelf.playerController.removeFromParent()
                            weakSelf.playerController.player?.pause()
                            weakSelf.playerController.player = nil
                        }
                    }
                }
                
            } else {
                status = .unknown
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromAVAudioSessionCategory(_ input: AVAudioSession.Category) -> String {
    return input.rawValue
}
