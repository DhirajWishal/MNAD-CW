//
//  LocationViewModel.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-29.
//

import Foundation
import Observation

@Observable class LocationViewModel {
    var locationInfo = LocationInfo()
    
    public func update(latitude: String, longitude: String, completed: ((String, String) -> Void)? = nil) {
        Geocoder.fetchLocation(latitude: latitude, longitude: longitude, completed: { placemark in
            guard let city = placemark.locality,
                  let country = placemark.country,
                  let coordinates = placemark.location?.coordinate,
                  let timeZone = placemark.timeZone?.abbreviation(),
                  let areasOfInterest = placemark.areasOfInterest
            else { return }
            
            self.locationInfo.city = city
            self.locationInfo.country = country
            self.locationInfo.latitude = String(coordinates.latitude)
            self.locationInfo.longitude = String(coordinates.longitude)
            self.locationInfo.timeZone = timeZone
            self.locationInfo.areasOfInterest = areasOfInterest
            
            guard let completed = completed else { return }
            completed(city, country)
        })
    }
}
