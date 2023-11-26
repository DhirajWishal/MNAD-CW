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
}
