//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import AVFoundation


class ViewController: UIViewController {
    var timeObserverToken: Any?
    
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    private var testComposition = AssetStore(assets: AssetDefinition.testAssets).compose()
    
    let playButton: PlayButton = {
        let btn = PlayButton()
        btn.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        btn.layer.cornerRadius = btn.frame.height / 2
        btn.alpha = 0.5
        btn.setImage(.play, for: .normal)
        btn.backgroundColor = .gray
        btn.tintColor = .black
        
        return btn
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButtonSetup()
    };
    
    func playButtonSetup() {
        self.view.addSubview(playButton)
        
        playButton.center = self.view.center
        playButton.customObject = testComposition
        
        print(playButton)
        
        playButton.addTarget(self, action: #selector(startPlaying(_:)), for: .touchUpInside)
    };
    
    @objc func startPlaying(_ sender: Any) {
        guard let asset = (sender as! PlayButton).customObject as? AVAsset else { return }
        
        playerItem = AVPlayerItem(asset: asset)
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = self.view.bounds
        self.view.layer.addSublayer(playerLayer)
        
        player.play()
        
        playButton.setImage(.pause, for: .normal)
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let self = self {
                self.playButtonToggle()
            }
        }
        
        self.view.bringSubviewToFront(playButton)
        
        player.actionAtItemEnd = .pause
        
        timeObserverToken = player.addBoundaryTimeObserver(forTimes: [NSValue(time: asset.duration)], queue: .main) {
            UIView.animate(withDuration: 0.3) {
                [weak self] in
                if let self = self {
                    self.playButton.setImage(.play, for: .normal)
                    self.playButtonToggle()
                    self.removeBoundaryTimeObserver()
                }
            }
        }
    };
    
    private func removeBoundaryTimeObserver() {
        if let timeObserverToken = timeObserverToken {
            player.removeTimeObserver(timeObserverToken)
            self.timeObserverToken = nil
        }
        
    };
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let self = self {
                self.playButtonToggle()
            }
        }
    };
    
    private func playButtonToggle() {
        self.playButton.isEnabled.toggle()
        self.playButton.alpha = playButton.isEnabled ? 0.5 : 0
    };
    
}



