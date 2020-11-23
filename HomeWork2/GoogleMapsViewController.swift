//
//  GoogleMapsViewController.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 12.11.2020.
//

import UIKit
import GoogleMaps

class GoogleMapsViewController: UIViewController {

    @IBOutlet weak var googleMapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        centerOnUser()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        getCurrentPosition()
    }

    func centerOnUser(){
        let lm = LocationData.shared
        if lm.currentLocation != nil {
            googleMapView.isMyLocationEnabled = true
            googleMapView.camera = GMSCameraPosition(target: lm.currentLocation!, zoom: 5)
        }
    }
    
}


