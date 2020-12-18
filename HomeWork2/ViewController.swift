//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController {
    
    // MARK: Properties
    private let cameraSession = AVCaptureSession()
    private lazy var previewLayer = AVCaptureVideoPreviewLayer(session: self.cameraSession)
    private let videoDataOutput = AVCaptureVideoDataOutput()
    private var faceLayers = [CAShapeLayer]()
    private var rocketFired = false
    
    // MARK: Standard Funcs
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCamera()
        cameraSession.startRunning()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.previewLayer.frame = self.view.frame
    }
    
    // MARK: Camera setup
    /// Detecting available camera
    private func setupCamera(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: .front)
        if let device = deviceDiscoverySession.devices.first{
            if let deviceInput = try? AVCaptureDeviceInput(device: device) {
                if cameraSession.canAddInput(deviceInput) {
                    cameraSession.addInput(deviceInput)
                    
                    setupPreview()
                }
            }
        }
    }
    
    /// Create video output to show
    private func setupPreview(){
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(self.previewLayer)
        self.previewLayer.frame = self.view.frame
        
        self.videoDataOutput.videoSettings = [(kCVPixelBufferPixelFormatTypeKey as NSString) : NSNumber(value: kCVPixelFormatType_32BGRA)] as [String : Any]
        self.videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "Camera queue"))
        
        self.cameraSession.addOutput(videoDataOutput)
        let videoConnection = self.videoDataOutput.connection(with: .video)
        videoConnection?.videoOrientation = .portrait
    }
    
    // MARK: Vision
    /// Handling Vision observations to detect faces in view
    private func handleFaceDetectionObservations(_ observations: [VNFaceObservation]) {
        for observation in observations {
            let faceRectConverted = self.previewLayer.layerRectConverted(fromMetadataOutputRect: observation.boundingBox)
            let faceRectPath = CGPath(rect: faceRectConverted, transform: nil)
            
            let faceLayer = CAShapeLayer()
            faceLayer.path = faceRectPath
            faceLayer.fillColor = UIColor.clear.cgColor
            faceLayer.strokeColor = UIColor.red.cgColor
            
            self.faceLayers.append(faceLayer)
            self.view.layer.addSublayer(faceLayer)
            
            if !rocketFired {
                fireRocket(at: faceLayer.path!)
            }
        }
    }
    
    private func fireRocket(at face: CGPath){
        rocketFired.toggle()
        
        let rocket = UIImageView(image: UIImage(named: "Rocket"))
        let explosion = UIImageView(image: UIImage(named: "Explosion"))
        
        rocket.frame = CGRect(origin: .zero, size: rocket.image!.size / 5)
        rocket.center = CGPoint(x: view.bounds.maxX / 2, y: view.bounds.height - (rocket.image?.size.height)! / 5)
        
        
        explosion.frame = CGRect(origin: .zero, size: explosion.image!.size / 8)
        explosion.center = face.center
        explosion.alpha = 0
        explosion.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        
        view.addSubview(rocket)
        view.addSubview(explosion)
        
        let distance = view.frame.size.width / min(face.boundingBox.size.width, face.boundingBox.size.height)
        let duration = Double(distance) * 0.45
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn) {
            rocket.center = explosion.center
        } completion: { ended in
            rocket.alpha = 0
            UIView.animate(withDuration: 0.7, delay: 0, options: .curveEaseOut, animations: {
                explosion.alpha = 1
                explosion.transform = CGAffineTransform(scaleX: 1, y: 1)
            }, completion: { _ in
                UIView.animate(withDuration: 0.7) {
                    explosion.alpha = 0
                    explosion.transform = CGAffineTransform(scaleX: 2, y: 2)
                } completion: { (_) in
                    DispatchQueue.global().async {
                        self.rocketFired.toggle()
                    }
                }

            })
        }
        
    }
    
}

// MARK: - AVCapture Extension
extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    /// Creating capture output to make observations
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return }
        
        let faceDetectionRequest = VNDetectFaceLandmarksRequest { (request, error) in
            DispatchQueue.main.async {
                self.faceLayers.forEach({ $0.removeFromSuperlayer() })
                
                if let observations = request.results as? [VNFaceObservation] {
                    self.handleFaceDetectionObservations(observations)
                }
            }
        }
        
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: imageBuffer, orientation: .leftMirrored)
        
        do {
            try imageRequestHandler.perform([faceDetectionRequest])
        } catch {
            print(error.localizedDescription)
        }
        
    }
    
}

extension CGSize {
    static func / (size: CGSize, division: CGFloat) -> CGSize {
        return CGSize(width: size.width / division, height: size.height / division)
    }
}

extension CGPath {
    var center: CGPoint {
        CGPoint(
            x: self.boundingBox.origin.x + self.boundingBox.width / 2,
            y: self.boundingBox.origin.y + self.boundingBox.height / 2
        )
    }
}
