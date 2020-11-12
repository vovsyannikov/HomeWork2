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
        
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let lm = LocationData.shared
        // Запрос разрешения геопозиции
        lm.requestAccess { successeded in
            if successeded {
                // Если разрешение получено, то запросить геопозицию
                lm.getLocation { [unowned self] (location) in
                    print(location!)
                    
                    // Приближение карты
                    let radius: CLLocationDistance = 500
                    // Задание региона с центром в текущей позиции (location) и приближением (radius)
                    let region: MKCoordinateRegion = .init(center: lm.currentLocation!, latitudinalMeters: radius, longitudinalMeters: radius)
                    
                    // Перемещение карты
                    self.appleMapView.setRegion(region, animated: true)
                }
            }
        }
    }
}

