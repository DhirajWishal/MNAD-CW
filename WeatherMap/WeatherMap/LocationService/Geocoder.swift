//
//  Geocoder.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import Foundation
import CoreLocation

extension CLLocation {
    func fetchCityAndCountry(completion: @escaping (_ city: String?, _ country:  String?, _ error: Error?) -> ()) {
        CLGeocoder().reverseGeocodeLocation(self) { completion($0?.first?.locality, $0?.first?.country, $1) }
    }
    
    func addressCompletion(addressString: String, handler: @escaping ([CLPlacemark]?, Error?) -> Void) {
        CLGeocoder().geocodeAddressString(addressString, completionHandler: handler)
    }
}

@Observable class Geocoder {
    public static func fetchLocation(latitude: String, longitude: String, completed: @escaping (String, String) -> Void) {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else {
            print("Failed to convert longitude and latitude.")
            return
        }
        
        let location = CLLocation(latitude: latitude, longitude: longitude)
        location.fetchCityAndCountry { city, country, error in
            guard let city = city, let country = country, error == nil else {
                print("Failed to get city and country info.")
                return
            }
            
            completed(city, country)
        }
    }
    
    public static func addressCompletion(address: String, handler: @escaping ([CLPlacemark]) -> Void) {
        let _ = CLLocation().addressCompletion(addressString: address) { (placemark, error) in
            guard let placemark = placemark else { return }
            handler(placemark)
        }
    }
    
    public static func fetchCoordinates(address: String, handler: @escaping (String, String) -> Void) {
        let _ = CLLocation().addressCompletion(addressString: address) { (placemark, error) in
            guard let placemark = placemark else { return }
            guard let first = placemark.first else { return }
            guard let location = first.location else { return }
            
            handler(String(location.coordinate.latitude), String(location.coordinate.longitude))
        }
    }
}
