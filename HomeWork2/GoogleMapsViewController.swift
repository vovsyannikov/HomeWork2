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
                case 10: btn.addAction(GcenterOnPOI(), for: .touchUpInside)
                case 20: btn.addAction(GzoomIn(), for: .touchUpInside)
                case 30: btn.addAction(GzoomOut(), for: .touchUpInside)
                case 40: btn.addAction(GcenterOnUser(), for: .touchUpInside)
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
    
    func GcenterOnPOI() -> UIAction{
        let action = UIAction{ [unowned self] _ in
            if markers.isEmpty {
                addMarkers()
            }
            let poiCenter = findPOICenter()
            googleMapView.camera = GMSCameraPosition(target: poiCenter, zoom: 13)
        }
        
        return action
    }
    func GzoomIn() -> UIAction {
        let action = UIAction{ [unowned self] _ in
            googleMapView.animate(toZoom: googleMapView.camera.zoom + 1)
        }
        
        return action
    }
    func GzoomOut() -> UIAction{
        let action = UIAction{ [unowned self] _ in
            googleMapView.animate(toZoom: googleMapView.camera.zoom - 1)
        }
        
        return action
    }
    func GcenterOnUser() -> UIAction{
        let action = UIAction{ [unowned self] _ in
            if googleMapView.myLocation != nil {
                let cameraOnUser = GMSCameraPosition(target: googleMapView.myLocation!.coordinate, zoom: 17)
                googleMapView.animate(to: cameraOnUser)
            }
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
            googleMapView.camera = GMSCameraPosition(target: lm.currentLocation!, zoom: 17)
        }
    }
    
}

extension GoogleMapsViewController: GMSMapViewDelegate{
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        // Вывод названия маркера в консоль. Ломает вывод на экран
        print(marker.title)
        return true
    }
}
