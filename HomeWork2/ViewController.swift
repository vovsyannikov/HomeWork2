//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    private var timeObserverToken: Any?
    
    private var playerItem: AVPlayerItem!
    private var player: AVPlayer!
    private var playerLayer: AVPlayerLayer!
    
    private var testComposition = AssetStore(assets: AssetDefinition.controlAssets).compose()
    
    private let playButton: PlayButton = {
        
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
    
    private func playButtonSetup() {
        view.addSubview(playButton)

        
        playButton.center = view.center
        (playButton.asset, playButton.composition) = testComposition
        
        playButton.addTarget(self, action: #selector(startPlaying(_:)), for: .touchUpInside)
    };
    
    
    @objc private func startPlaying(_ sender: Any) {
        guard let playButton = sender as? PlayButton,
              let asset = playButton.asset,
              let composition = playButton.composition
        else { return }
        
        playerItem = AVPlayerItem(asset: asset)
        playerItem.videoComposition = composition
        player = AVPlayer(playerItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.videoGravity = .resizeAspect
        playerLayer.setAffineTransform(CGAffineTransform(rotationAngle: CGFloat.pi / 2))
        playerLayer.frame = view.bounds
        view.layer.addSublayer(playerLayer)
        
        player.play()
        
        playButton.setImage(.replay, for: .normal)
        UIView.animate(withDuration: 0.3) { [weak self] in
            if let self = self {
                self.playButtonToggle()
            }
        }
        
        view.bringSubviewToFront(playButton)
        
        addBoundaryTimeObserver(for: asset)
    };
    
    private func addBoundaryTimeObserver(for asset: AVAsset) {
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



