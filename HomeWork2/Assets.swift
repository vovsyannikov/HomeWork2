//
//  Assets.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 20.12.2020.
//

import UIKit
import AVFoundation

struct AssetDefinition: Hashable {
    let name: String
    let type: String?
    let assetType: AVMediaType
    
    static let controlAssets: [AssetDefinition] = [
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
            default: break
            }
        }
    };
    
    private func createAsset(for asset: AssetDefinition) -> AVAsset {
        guard let path = Bundle.main.path(forResource: asset.name, ofType: asset.type) else { fatalError() }
        let url = URL(fileURLWithPath: path)
        return AVAsset(url: url)
    };
    
    
    fileprivate func addTransitions(to finalComposition: AVMutableComposition, for videoTracks: [AVMutableCompositionTrack],
                                    transitionDuration: CMTime = .init(seconds: 1, preferredTimescale: 600)
) -> AVMutableVideoComposition {
        let firstTransitionRange = CMTimeRange(start: videoFiles[0].duration - transitionDuration,                           duration: transitionDuration)
        let secondTransitionRange = CMTimeRange(start: videoFiles[0].duration + videoFiles[1].duration - transitionDuration, duration: transitionDuration)
        
        let videoComposition = AVMutableVideoComposition(propertiesOf: finalComposition)
        
        let firstTransitionInstruction = AVMutableVideoCompositionInstruction()
        firstTransitionInstruction.timeRange = firstTransitionRange
        
        let rightVideoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTracks[0])
        rightVideoLayerInstruction.setTransform(CGAffineTransform(translationX: 1_000, y: 0), at: videoFiles[0].duration - transitionDuration)
        
        let leftVideoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTracks[1])
        leftVideoLayerInstruction.setTransformRamp(fromStart: CGAffineTransform(translationX: -1_000, y: 0),
                                                   toEnd:     CGAffineTransform(translationX: +0_000, y: 0),
                                                   timeRange: firstTransitionRange)
        
        firstTransitionInstruction.layerInstructions = [rightVideoLayerInstruction, leftVideoLayerInstruction]
        
        let secondTransitionInstruction = AVMutableVideoCompositionInstruction()
        secondTransitionInstruction.timeRange = secondTransitionRange
        
        let newVideoLayerInstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTracks[2])
        newVideoLayerInstruction.setTransformRamp(fromStart: CGAffineTransform(scaleX: 0.001, y: 0.001),
                                                  toEnd:     CGAffineTransform(scaleX: 1.000, y: 1.000),
                                                  timeRange: secondTransitionRange)
        
        secondTransitionInstruction.layerInstructions = [newVideoLayerInstruction]
        
        let passthroughInstructions = Array(repeating: AVMutableVideoCompositionInstruction(), count: 3)
        
        passthroughInstructions[0].timeRange = CMTimeRange(start: .zero,                                       duration: firstTransitionRange.start)
        passthroughInstructions[1].timeRange = CMTimeRange(start: videoFiles[0].duration + transitionDuration, duration: videoFiles[1].duration - transitionDuration)
        passthroughInstructions[2].timeRange = CMTimeRange(start: videoFiles[1].duration + transitionDuration, duration: videoFiles[2].duration)
        
        let passthroughLayerInstruction1 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTracks[0])
        let passthroughLayerInstruction2 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTracks[1])
        let passthroughLayerInstruction3 = AVMutableVideoCompositionLayerInstruction(assetTrack: videoTracks[2])
        
        passthroughLayerInstruction1.setTransform(videoTracks[0].preferredTransform, at: .zero)
        passthroughLayerInstruction2.setTransform(videoTracks[1].preferredTransform, at: .zero)
        passthroughLayerInstruction3.setTransform(videoTracks[2].preferredTransform, at: .zero)
        
        passthroughInstructions[0].layerInstructions = [passthroughLayerInstruction1]
        passthroughInstructions[1].layerInstructions = [passthroughLayerInstruction2]
        passthroughInstructions[2].layerInstructions = [passthroughLayerInstruction3]
        
        videoComposition.instructions = [ passthroughInstructions[0],
                                          firstTransitionInstruction,
                                          passthroughInstructions[1],
                                          secondTransitionInstruction,
                                          passthroughInstructions[2] ]
        
        return videoComposition
    }
    
    func compose() -> (asset: AVAsset, composition: AVVideoComposition) {
        let trackID = Int32(kCMPersistentTrackID_Invalid)
        let finalComposition = AVMutableComposition()
        
        guard let videoTrack1 = finalComposition.addMutableTrack(withMediaType: .video, preferredTrackID: trackID),
              let videoTrack2 = finalComposition.addMutableTrack(withMediaType: .video, preferredTrackID: trackID),
              let videoTrack3 = finalComposition.addMutableTrack(withMediaType: .video, preferredTrackID: trackID)
        else { fatalError() }
        
        guard let audioTrack = finalComposition.addMutableTrack(withMediaType: .audio, preferredTrackID: trackID) else { fatalError() }
    
        var currentVideoDuration = CMTime.zero
        var currentAudioDuration = CMTime.zero
        let transitionDuration = CMTime(seconds: 1, preferredTimescale: 600)

        let allVideoTracks = [videoTrack1, videoTrack2, videoTrack3]
        
        for (index, video) in videoFiles.enumerated() {
            insert(video, at: currentVideoDuration, in: allVideoTracks[index])
            currentVideoDuration += video.duration + transitionDuration
        }
        
        for song in audioFiles {
            insert(song, at: currentAudioDuration, in: audioTrack)
            currentAudioDuration += song.duration
        }

        let videoComposition = addTransitions(to: finalComposition,
                                              for: allVideoTracks,
                                              transitionDuration: transitionDuration)
        
        print("Overall duration of video: \(currentVideoDuration.seconds)")
        print("Overall duration of audio: \(currentAudioDuration.seconds)")
        
        return (finalComposition, videoComposition)
    };
    

    func insert(_ asset: AVAsset, at time: CMTime, in track: AVMutableCompositionTrack) {
        try? track.insertTimeRange(
            CMTimeRange(start: .zero,
                        duration: asset.duration),
            of: asset.tracks(withMediaType: track.mediaType)[0],
            at: time)
    };

}

class PlayButton: UIButton {
    var asset: AVAsset? = nil
    var composition: AVVideoComposition? = nil
}

extension CMTime {
    static func += (lhs: inout CMTime, rhs: CMTime) {
        lhs = lhs + rhs
    }
}

extension UIImage {
    static let play = UIImage(systemName: "arrowtriangle.right.fill")
    static let replay = UIImage(systemName: "gobackward")
}
