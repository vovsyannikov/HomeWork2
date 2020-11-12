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
        
        createAnnotations()
        getCurrentPosition()
        
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
    }
    func getCurrentPosition(){
        let lm = LocationData.shared
        // Запрос разрешения геопозиции
        lm.requestAccess { successeded in
            if successeded {
                // Если разрешение получено, то запросить геопозицию
                lm.getLocation { [unowned self] (location) in
                    print(location!)
                    
                    // Приближение карты
                    let radius: CLLocationDistance = 1_000
                    // Задание региона с центром в текущей позиции (location) и приближением (radius)
                    let region: MKCoordinateRegion = .init(center: lm.currentLocation!, latitudinalMeters: radius, longitudinalMeters: radius)
                    
                    // Перемещение карты
//                    self.appleMapView.setRegion(region, animated: true)
                }
            }
        }
    }
}

extension ViewController: MKMapViewDelegate{
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation { return nil }
        let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "annotationView") ?? MKAnnotationView()
        
        return annotationView
    }
}

