//
//  LocationManager.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-27.
//

import Foundation
import CoreLocation
import Observation

@Observable class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        print("Location authorization requested.")
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("Location manager called. status: \(status)")
        
        if status == .authorizedAlways {
            print("Location authorization received.")
            
            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
                if CLLocationManager.isRangingAvailable() {
                    // do stuff
                }
            }
        } else if status == .denied {
            print("Location authorization denied!")
        }
    }
}
