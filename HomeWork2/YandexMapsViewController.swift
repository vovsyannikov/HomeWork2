//
//  YandexMapsViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 12.11.2020.
//

import UIKit
import YandexMapKit

class YandexMapsViewController: UIViewController {

    @IBOutlet weak var yandexMapView: YMKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        createButtons { [unowned self] (buttonStack) in
            buttonStack.center = CGPoint(x: view.bounds.maxX - buttonStack.frame.width, y: view.center.y)
            
            for el in buttonStack.arrangedSubviews {
                let btn = el as! UIButton
                switch btn.tag {
                case 10: btn.addAction(YcenterOnPOI(), for: .touchUpInside)
                case 20: btn.addAction(YzoomIn(), for: .touchUpInside)
                case 30: btn.addAction(YzoomOut(), for: .touchUpInside)
                case 40: btn.addAction(YcenterOnUser(), for: .touchUpInside)
                default: break
                }
            }

            view.addSubview(buttonStack)
        }
    }
    
    func YcenterOnPOI() -> UIAction{
        let action = UIAction { [unowned self] _ in
            let poiCenter = findPOICenter()
            var cameraPosition = yandexMapView.mapWindow.map.cameraPosition
            cameraPosition = YMKCameraPosition(target: YMKPoint(latitude: poiCenter.latitude, longitude: poiCenter.longitude), zoom: 10, azimuth: cameraPosition.azimuth, tilt: cameraPosition.tilt)
            
            moveYMKCamera(to: cameraPosition)
        }
        
        return action
    }
    func YzoomIn() -> UIAction{
        let action = UIAction { [unowned self] _ in
            var cameraPosition = yandexMapView.mapWindow.map.cameraPosition
            cameraPosition = YMKCameraPosition(target: cameraPosition.target, zoom: cameraPosition.zoom + 1, azimuth: cameraPosition.azimuth, tilt: cameraPosition.tilt)
            
            moveYMKCamera(to: cameraPosition, duration: 0.3)
        }
        
        return action
    }
    func YzoomOut() -> UIAction{
        let action = UIAction { [unowned self] _ in
            var cameraPosition = yandexMapView.mapWindow.map.cameraPosition
            cameraPosition = YMKCameraPosition(target: cameraPosition.target, zoom: cameraPosition.zoom - 1, azimuth: cameraPosition.azimuth, tilt: cameraPosition.tilt)
            
            moveYMKCamera(to: cameraPosition, duration: 0.3)
        }
        
        return action
    }
    func YcenterOnUser() -> UIAction{
        let action = UIAction { [unowned self] _ in
            let lm = LocationData.shared
            if lm.currentLocation != nil {
                let userPoint = YMKPoint(latitude: lm.currentLocation!.latitude, longitude: lm.currentLocation!.longitude)
                var cameraPosition = yandexMapView.mapWindow.map.cameraPosition
                cameraPosition = YMKCameraPosition(target: userPoint, zoom: 25, azimuth: cameraPosition.azimuth, tilt: cameraPosition.tilt)
                
                moveYMKCamera(to: cameraPosition)
            }
        }
        
        return action
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startUp()
        createPlacemarks()
    }
    
    func moveYMKCamera(to postition: YMKCameraPosition, duration: Float = 2){
        yandexMapView.mapWindow.map.move (
            with: postition,
            animationType: YMKAnimation(type: .smooth, duration: duration),
            cameraCallback: nil
        )
    }
    
    func startUp(){
        getCurrentPosition()
        
        let lm = LocationData.shared
        if lm.currentLocation != nil {
            let point = YMKPoint(latitude: lm.currentLocation!.latitude, longitude: lm.currentLocation!.longitude)
            moveYMKCamera(to: YMKCameraPosition(target: point, zoom: 25, azimuth: 0, tilt: 0))
            
            
            let scale = UIScreen.main.scale
            let mapKit = YMKMapKit.sharedInstance()
            let userLocationLayer = mapKit.createUserLocationLayer(with: yandexMapView.mapWindow)
            
            userLocationLayer.setVisibleWithOn(true)
            userLocationLayer.isHeadingEnabled = true
            userLocationLayer.setAnchorWithAnchorNormal(
                CGPoint(x: 0.5 * yandexMapView.frame.size.width * scale, y: 0.5 * yandexMapView.frame.size.height * scale),
                anchorCourse: CGPoint(x: 0.5 * yandexMapView.frame.size.width * scale, y: 0.83 * yandexMapView.frame.size.height * scale))
            userLocationLayer.setObjectListenerWith(self)
        }
        
    }
    
    func createPlacemarks(){
        let mapObjects = yandexMapView.mapWindow.map.mapObjects
        var yPoints: [YMKPoint] = []
        for place in places {
            mapObjects.addPlacemark(with: YMKPoint(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude), image: UIImage(systemName: "mappin.circle.fill")!)
        }
        
    }

}

extension YandexMapsViewController: YMKUserLocationObjectListener{
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(systemName:"arrowtriangle.up")!)
        
        let pinPlacemark = view.pin.useCompositeIcon()
        let userLocationImage = UIImage(systemName: "circle.fill")!.withTintColor(.systemRed)
        print(userLocationImage)
        
        pinPlacemark.setIconWithName(
            "pin",
            image: userLocationImage,
            style:YMKIconStyle(
                anchor: CGPoint(x: 0.5, y: 0.5) as NSValue,
                rotationType: YMKRotationType.rotate.rawValue as NSNumber,
                zIndex: 1,
                flat: true,
                visible: true,
                scale: 1,
                tappableArea: nil))
        
        view.accuracyCircle.fillColor = .blue
        view.accuracyCircle.strokeWidth = 1
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {}
    
    
}
extension YandexMapsViewController: YMKLocationDelegate{
    func onLocationUpdated(with location: YMKLocation) {
        print(location)
    }
    
    func onLocationStatusUpdated(with status: YMKLocationStatus) {
        print(status)
    }
    
    
}
