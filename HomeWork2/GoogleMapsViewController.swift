//
//  GoogleMapsViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 12.11.2020.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {

    var markers: [GMSMarker] = []
    @IBOutlet weak var googleMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createButtons { (buttonStack) in
            buttonStack.center = CGPoint(x: view.bounds.maxX - buttonStack.frame.width, y: view.center.y)
            
            for el in buttonStack.arrangedSubviews {
                let btn = el as! UIButton
                switch btn.tag {
                case 10: btn.addAction(poiZoom(), for: .touchUpInside)
                case 20: btn.addAction(zoomIn(), for: .touchUpInside)
                case 30: btn.addAction(zoomOut(), for: .touchUpInside)
                case 40: btn.addAction(centerOnUser(), for: .touchUpInside)
                default: break
                }
            }
            self.view.addSubview(buttonStack)
        }
        
    }
    func addMarkers(){
        for place in places{
            //Создание маркера по координате и названию
            let marker = GMSMarker(position: place.coordinate)
            marker.title = place.title
    
            //Добавление маркера в массив и привязка к карте
            markers.append(marker)
            markers.last!.map = googleMapView
        }
    }
    func findPOICenter() -> CLLocationCoordinate2D {
        
        var leftmostPoint: CLLocationDegrees = places[0].coordinate.latitude
        var rightmostPoint: CLLocationDegrees = places[0].coordinate.latitude
        var topPoint: CLLocationDegrees = places[0].coordinate.longitude
        var bottomPoint: CLLocationDegrees = places[0].coordinate.longitude
        
        for place in places {
            if place.coordinate.latitude < leftmostPoint {
                leftmostPoint = place.coordinate.latitude
            }
            if place.coordinate.latitude > rightmostPoint {
                rightmostPoint = place.coordinate.latitude
            }
            if place.coordinate.longitude > topPoint {
                topPoint = place.coordinate.longitude
            }
            if place.coordinate.longitude < bottomPoint {
                bottomPoint = place.coordinate.longitude
            }
        }
        
        return CLLocationCoordinate2D(latitude: (leftmostPoint + rightmostPoint)/2, longitude: (topPoint + bottomPoint)/2 )
    }
    func poiZoom() -> UIAction{
        
        let action = UIAction{ [unowned self] _ in
            if markers.isEmpty {
                addMarkers()
            }
            let poiCenter = findPOICenter()
            googleMapView.camera = GMSCameraPosition(target: poiCenter, zoom: 20)
        }
        
        return action
    }
    func zoomIn() -> UIAction {
        let action = UIAction{ [unowned self] _ in
            googleMapView.animate(toZoom: googleMapView.camera.zoom * 5)
            
        }
        
        return action
    }
    func zoomOut() -> UIAction{
        let action = UIAction{ [unowned self] _ in
            googleMapView.animate(toZoom: googleMapView.camera.zoom / 5)
        }
        
        return action
    }
    func centerOnUser() -> UIAction{
        let action = UIAction{ [unowned self] _ in
            
        }
        
        return action
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        googleMapView.delegate = self
        startUp()
    }

    func startUp(){
        getCurrentPosition()
        
        let lm = LocationData.shared
        if lm.currentLocation != nil {
            googleMapView.isMyLocationEnabled = true
            googleMapView.camera = GMSCameraPosition(target: lm.currentLocation!, zoom: 10)
        }
    }
    
}

extension GoogleMapsViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        print(marker.title)
        return true
    }
}
