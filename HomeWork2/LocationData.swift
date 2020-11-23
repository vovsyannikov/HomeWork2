//
//  LocationData.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 12.11.2020.
//

import Foundation
import CoreLocation
import MapKit

let places: [Place] = [
    Place(title: "Красная площадь", coordinate: CLLocationCoordinate2D(latitude: 55.754012, longitude: 37.620537)),
    Place(title: "Парк Горького", coordinate: CLLocationCoordinate2D(latitude: 55.727029, longitude: 37.599901)),
    Place(title: "Парк Зарядье", coordinate: CLLocationCoordinate2D(latitude: 55.751018, longitude: 37.628694)),
    Place(title: "Храм Христа Спасителя", coordinate: CLLocationCoordinate2D(latitude: 55.744288, longitude: 37.605189)),
    Place(title: "Большой Театр", coordinate: CLLocationCoordinate2D(latitude: 55.759936, longitude: 37.618677))
]

public func createButtons(completion: (UIStackView) -> ()){
    let poiButton = UIButton()
    let zoomInButton = UIButton()
    let zoomOutButton = UIButton()
    let centerButton = UIButton()
    let vStack = UIStackView()
    
    vStack.frame = CGRect(x: 0, y: 0, width: 50, height: 200)
    
    vStack.axis = .vertical
    vStack.distribution = .fillEqually
    vStack.spacing = 5
    
    zoomInButton.setImage(UIImage(systemName: "plus"), for: .normal)
    zoomOutButton.setImage(UIImage(systemName: "minus"), for: .normal)
    poiButton.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
    centerButton.setImage(UIImage(systemName: "arrowtriangle.up"), for: .normal)
    centerButton.transform = CGAffineTransform(rotationAngle: -(.pi/4))
    
    poiButton.tag = 10
    zoomInButton.tag = 20
    zoomOutButton.tag = 30
    centerButton.tag = 40
    
    for btn in [poiButton, zoomInButton, zoomOutButton, centerButton] {
        btn.backgroundColor = .systemGray4
        btn.imageView?.tintColor = .black
        btn.layer.cornerRadius = vStack.frame.width/2
        vStack.addArrangedSubview(btn)
    }
    
    completion(vStack)
}

class Place: NSObject, MKAnnotation{
    var title: String?
    var coordinate: CLLocationCoordinate2D
    init(title: String?, coordinate: CLLocationCoordinate2D){
        self.coordinate = coordinate
        self.title = title
    }
}

class LocationData: NSObject {
    static let shared = LocationData()
    var currentLocation: CLLocationCoordinate2D? // Текущее положение пользователя
    
    typealias AccessRequestBlock = (Bool) -> ()
    typealias LocationRequestBlock = (CLLocationCoordinate2D?) -> ()
    
    private let locationManager = CLLocationManager()
    
    var isEnabled: Bool {
        return locationManager.authorizationStatus == .authorizedAlways || locationManager.authorizationStatus == .authorizedWhenInUse
    }
    var canRequestAccess: Bool {
        return locationManager.authorizationStatus != .restricted && locationManager.authorizationStatus != .denied
    }
    
    private var accessRequestCompletion: AccessRequestBlock?
    private var locationRequestCompletion: LocationRequestBlock?
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }
    
    func requestAccess(completion: AccessRequestBlock?){
        accessRequestCompletion = completion
        locationManager.requestWhenInUseAuthorization()
    }
    
    func getLocation(completion: LocationRequestBlock?){
        locationRequestCompletion = completion
        locationManager.startUpdatingLocation()
    }
}

extension LocationData: CLLocationManagerDelegate{
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print(manager.authorizationStatus)
        if manager.authorizationStatus == .authorizedAlways || manager.authorizationStatus == .authorizedWhenInUse{
            accessRequestCompletion?(true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = manager.location?.coordinate else { return }
        currentLocation = location
        locationRequestCompletion?(location)
        locationRequestCompletion = nil
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        manager.stopUpdatingLocation()
        locationRequestCompletion?(nil)
        locationRequestCompletion = nil
    }
}

extension CLAuthorizationStatus: CustomStringConvertible{
    public var description: String {
        switch self {
        case .authorizedAlways:
            return "Always authorized"
        case .notDetermined:
            return "Not determined"
        case .restricted:
            return "Restricted"
        case .denied:
            return "Denied"
        case .authorizedWhenInUse:
            return "Authorized when in use"
        @unknown default:
            return "Unknown"
        }
    }
}
