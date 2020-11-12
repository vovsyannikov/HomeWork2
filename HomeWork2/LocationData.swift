//
//  LocationData.swift
//  HomeWork2
//
//  Created by Виталий Овсянников on 12.11.2020.
//

import Foundation
import CoreLocation

class LocationData: NSObject {
    static let shared = LocationData()
    var currentLocation: CLLocationCoordinate2D?
    
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
