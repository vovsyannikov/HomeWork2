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

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lm = LocationData.shared
        
        if lm.currentLocation != nil {
            
        }
    }

}
