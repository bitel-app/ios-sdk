//
//  BitelLocationService.swift
//  Pods
//
//  Created by mohsen shakiba on 6/1/1396 AP.
//
//

import Foundation
import CoreLocation

class BitelLocationService: NSObject {
    
    static let `default` = BitelLocationService()
    
    internal var phone: String? = nil
    internal var token: String? = nil
    internal var locationManager = CLLocationManager()
    
    private override init() {
        super.init()
    }
    
    func requestLocation(for phone: String, token: String) {
        self.phone = phone
        self.token = token
        if isLocationsEnabled() {
            requestLocationAccess()
        }
    }
    
    /// checks if locations are enbled
    private func isLocationsEnabled() -> Bool {
        if CLLocationManager.locationServicesEnabled() {
            switch(CLLocationManager.authorizationStatus()) {
            case .notDetermined, .restricted, .denied: return false
            case .authorizedAlways, .authorizedWhenInUse: return true
            }
        } else {
            return false
        }
    }
    
    private func requestLocationAccess() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    internal func sendLocationsToServer(lat: Double, long: Double) {
        guard let phone = self.phone, let token = self.token else { return }
        let param: Parameters = [
            "latitude": lat,
            "longitude": long,
            "phone": phone
        ]
        _ = HttpService.default.post(path: .lbs, data: param, token: token)
        self.token = nil
        self.phone = nil
    }
    
}

extension BitelLocationService: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locationManager.stopUpdatingLocation()
        guard let location = locations.first else { return }
        sendLocationsToServer(lat: location.coordinate.latitude, long: location.coordinate.longitude)
    }
    
}
