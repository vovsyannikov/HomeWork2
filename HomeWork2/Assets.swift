//
//  Assets.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 20.12.2020.
//

import UIKit
import AVFoundation

enum AssetType: String {
    case video
    case audio
}



struct AssetDefinition: Hashable {
    let name: String
    let type: String?
    let assetType: AssetType
    
    static let testAssets: [AssetDefinition] = [
        AssetDefinition(name: "Video1", type: "MOV", assetType: .video),
        AssetDefinition(name: "Video2", type: "MOV", assetType: .video),
        AssetDefinition(name: "Video3", type: "MOV", assetType: .video),
        AssetDefinition(name: "Video4", type: "MOV", assetType: .video), // TODO: Remove last unnecessary asset
        AssetDefinition(name: "Song2", type: "m4a", assetType: .audio),
        AssetDefinition(name: "Song1", type: "m4a", assetType: .audio)
    ]
    
}



class AssetStore {
    var videoFiles: [AVAsset] = []
    var audioFiles: [AVAsset] = []
    
    init(assets: [AssetDefinition]){
        
        for (asset) in assets {
            let newAsset = createAsset(for: asset)
            
            switch asset.assetType {
            case .video: self.videoFiles.append(newAsset)
            case .audio: self.audioFiles.append(newAsset)
            }
        }
    };
    
    private func createAsset(for asset: AssetDefinition) -> AVAsset {
        guard let path = Bundle.main.path(forResource: asset.name, ofType: asset.type) else { fatalError() }
        let url = URL(fileURLWithPath: path)
        return AVAsset(url: url)
    };
    
    
    func compose() -> AVAsset {
        let trackID = Int32(kCMPersistentTrackID_Invalid)
        let finalComposition = AVMutableComposition()
        
        guard let videoTrack = finalComposition.addMutableTrack(withMediaType: .video, preferredTrackID: trackID) else { fatalError() }
        guard let audioTrack = finalComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: trackID) else { fatalError() }
        
        func insert(_ asset: AVAsset, at time: CMTime, in track: AVMutableCompositionTrack) {
            try? track.insertTimeRange(
                CMTimeRange(start: .zero, duration: asset.duration),
                of: asset.tracks(withMediaType: track.mediaType)[0],
                at: time)
        };
        
        var currentVideoDuration = CMTime.zero
        var currentAudioDuration = CMTime.zero
        
        for video in videoFiles {
            insert(video, at: currentVideoDuration, in: videoTrack)
            currentVideoDuration += video.duration
        }
        
        for song in audioFiles {
            insert(song, at: currentAudioDuration, in: audioTrack)
            currentAudioDuration += song.duration
        }
        
        print("Overall duration of video: \(currentVideoDuration.seconds)")
        print("Overall duration of audio: \(currentAudioDuration.seconds)")
        
        return finalComposition
    };
    
}

class PlayButton: UIButton {
    var customObject: Any? = nil
}

extension CMTime {
    static func += (lhs: inout CMTime, rhs: CMTime) {
        lhs = lhs + rhs
    }
}

extension UIImage {
    static let play = UIImage(systemName: "arrowtriangle.right.fill")
    static let pause = UIImage(systemName: "pause.fill")
}
