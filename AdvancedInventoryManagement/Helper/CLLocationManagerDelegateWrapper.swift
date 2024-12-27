//
//  CLLocationManagerDelegateWrapper.swift
//  AdvancedInventoryManagement
//
//  Created by rifqi triginandri on 26/12/24.
//

import SwiftUI
import MapKit

// Wrapper untuk CLLocationManager
class CLLocationManagerDelegateWrapper: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationManager: CLLocationManager
    var onLocationUpdate: ((CLLocation?) -> Void)?
    
    override init() {
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        onLocationUpdate?(locations.last)
        manager.stopUpdatingLocation() // Stop setelah mendapatkan lokasi
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location: \(error.localizedDescription)")
    }
}
