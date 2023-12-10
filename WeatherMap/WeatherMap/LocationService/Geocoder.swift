//
//  Geocoder.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import Foundation
import CoreLocation

extension CLLocation {
    func fetchLocation(completion: @escaping (_ location: CLPlacemark?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first, $1) }
    }
    
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
    func addressCompletion(addressString: String, handler: @escaping ([CLPlacemark]?, Error?) -> Void) {
        CLGeocoder().geocodeAddressString(addressString, completionHandler: handler)
    }
}

class Geocoder {
    public static func fetchLocation(latitude: Double, longitude: Double, completed: @escaping (String, String) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else {
                print("Failed to get city and country info.")
                return
            }
            
            completed(city, country)
        }
    }
    
    public static func fetchLocation(latitude: Double, longitude: Double, completed: @escaping (CLPlacemark) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.fetchLocation { location, error in
            guard let location = location, error == nil else {
                print("Failed to get city and country info.")
                return
            }
            
            completed(location)
        }
    }
    
    public static func addressCompletion(address: String, handler: @escaping ([CLPlacemark]) -> Void) {
        let _ = CLLocation().addressCompletion(addressString: address) { (placemark, error) in
            guard let placemark = placemark else { return }
            handler(placemark)
        }
    }
    
    public static func fetchCoordinates(address: String, handler: @escaping (Double, Double) -> Void) {
        let _ = CLLocation().addressCompletion(addressString: address) { (placemark, error) in
            guard let placemark = placemark else { return }
            guard let first = placemark.first else { return }
            guard let location = first.location else { return }
            
            handler(location.coordinate.latitude, location.coordinate.longitude)
        }
    }
    
    public static func isValidLocation(latitude: Double, longitude: Double, completion: @escaping (Bool) -> Void) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let _ = city, let _ = country, error == nil else {
                print("Failed to get city and country info.")
                completion(false)
                return
            }
            
            completion(true)
        }
    }
}
