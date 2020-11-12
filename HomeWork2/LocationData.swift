//
//  LocationData.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 12.11.2020.
//

import Foundation
import CoreLocation
import MapKit

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
