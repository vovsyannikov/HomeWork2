//
//  ViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 07.10.2020.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    @IBOutlet weak var appleMapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        appleMapView.delegate = self
        createButtons { (vStack) in
            vStack.center = CGPoint(x: view.bounds.maxX - vStack.frame.width, y: view.center.y)
            
            for el in vStack.arrangedSubviews {
                let btn = el as! UIButton
                switch btn.tag {
                case 10: btn.addAction(poiZoom(), for: .touchUpInside)
                case 20: btn.addAction(zoomIn(), for: .touchUpInside)
                case 30: btn.addAction(zoomOut(), for: .touchUpInside)
                case 40: btn.addAction(centerOnUser(), for: .touchUpInside)
                default: break
                }
            }
            
            self.view.addSubview(vStack)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        startUp()
    }
    
    func startUp(){
        
        getCurrentPosition()
        
        let lm = LocationData.shared
        if lm.currentLocation != nil {
            appleMapView.setCenter(lm.currentLocation!, animated: true)
            appleMapView.camera.altitude = 2_000
        }
    }
    
    func createCamera(forLocation loc: CLLocationCoordinate2D) -> MKMapCamera {
        // Creating camera that looks at the location
        let camera = MKMapCamera(lookingAtCenter: loc, fromDistance: 2_000, pitch: 0, heading: appleMapView.camera.heading)
        
        return camera
    }
    func zoomIn() -> UIAction{
        let zoomInAction = UIAction{ [unowned self] _ in
            print("Zooming in")
            
            // Creating camera that is twice as far as current one
            let camera = createCamera(forLocation: appleMapView.centerCoordinate)
            camera.centerCoordinateDistance = appleMapView.camera.altitude / 2
            
            // Zooming map
            appleMapView.setCamera(camera, animated: true)
            
        }
        
        return zoomInAction
    }
    func zoomOut() -> UIAction{
        let zoomOutAction = UIAction{ [unowned self] _ in
            print("Zooming out")
            
            // Creating camera that is twice as close as current one
            let camera = createCamera(forLocation: appleMapView.centerCoordinate)
            camera.centerCoordinateDistance = appleMapView.camera.altitude * 2
            
            // Zooming map
            appleMapView.setCamera(camera, animated: true)
        }
        
        return zoomOutAction
    }
    func centerOnUser() -> UIAction {
        let centerOnUserAction = UIAction { [unowned self] _ in
            let lm = LocationData.shared
            guard let currentLoc = lm.currentLocation else { return }
            
            let camera = createCamera(forLocation: currentLoc)
            
            // Moving camera
            appleMapView.setCamera(camera, animated: true)
        }
        
        return centerOnUserAction
    }
    func poiZoom() -> UIAction{
        let poiZoomAction = UIAction { [unowned self] _ in
            if appleMapView.annotations.isEmpty {
                appleMapView.addAnnotations(places)
            }
            appleMapView.showAnnotations(places, animated: true)
        }
        
        return poiZoomAction
    }
    
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation!.title!!)
    }
}

