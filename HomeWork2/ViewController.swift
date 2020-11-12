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
                case 10: btn.addAction(zoomIn(), for: .touchUpInside)
                case 20: btn.addAction(zoomOut(), for: .touchUpInside)
                case 30: btn.addAction(centerOnUser()!, for: .touchUpInside)
                default: break
                }
            }
            
            self.view.addSubview(vStack)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        createAnnotations()
        getCurrentPosition()
        
    }
    
    func zoomIn() -> UIAction{
        let zoomInAction = UIAction{ [unowned self] _ in
            print("Zooming in")
            
            // Creating camera that is twice as far as current one
            let camera: MKMapCamera = .init(lookingAtCenter: appleMapView.centerCoordinate, fromDistance: appleMapView.camera.altitude / 2, pitch: 0, heading: appleMapView.camera.heading)
            
            // Zooming map
            appleMapView.setCamera(camera, animated: true)
            
        }
        
        return zoomInAction
    }
    func zoomOut() -> UIAction{
        let zoomOutAction = UIAction{ [unowned self] _ in
            print("Zooming out")
            
            // Creating camera that is twice as close as current one
            let camera: MKMapCamera = .init(lookingAtCenter: appleMapView.centerCoordinate, fromDistance: appleMapView.camera.altitude * 2, pitch: 0, heading: appleMapView.camera.heading)
            
            // Zooming map
            appleMapView.setCamera(camera, animated: true)
        }
        
        return zoomOutAction
    }
    func centerOnUser() -> UIAction? {
        let centerOnUserAction = UIAction { [unowned self] _ in
            let lm = LocationData.shared
            guard let currentLoc = lm.currentLocation else { return }
            
            // Creating camera that looks at the user
            let camera = MKMapCamera(lookingAtCenter: currentLoc, fromDistance: 2_000, pitch: 0, heading: appleMapView.camera.heading)
            
            // Moving camera
            appleMapView.setCamera(camera, animated: true)
        }
        
        return centerOnUserAction
    }
    func createAnnotations(){
        let places: [Place] = [
            Place(title: "Красная площадь", coordinate: CLLocationCoordinate2D(latitude: 55.754012, longitude: 37.620537)),
            Place(title: "Парк Горького", coordinate: CLLocationCoordinate2D(latitude: 55.727029, longitude: 37.599901)),
            Place(title: "Парк Зарядье", coordinate: CLLocationCoordinate2D(latitude: 55.751018, longitude: 37.628694)),
            Place(title: "Храм Христа Спасителя", coordinate: CLLocationCoordinate2D(latitude: 55.744288, longitude: 37.605189)),
            Place(title: "Большой Театр", coordinate: CLLocationCoordinate2D(latitude: 55.759936, longitude: 37.618677))
        ]
        
        appleMapView.addAnnotations(places)
        appleMapView.showAnnotations(places, animated: true)
        print(appleMapView.camera.altitude)
    }
    func getCurrentPosition(){
        let lm = LocationData.shared
        // Запрос разрешения геопозиции
        lm.requestAccess { (successeded) in
            if successeded {
                // Если разрешение получено, то запросить геопозицию
                lm.getLocation { (location) in
                    print(location!)
                }
            }
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        print(view.annotation!.title!!)
    }
}

