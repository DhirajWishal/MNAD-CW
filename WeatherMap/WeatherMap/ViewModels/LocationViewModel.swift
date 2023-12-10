//
//  LocationViewModel.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-29.
//

import Foundation
import Observation

@Observable class LocationViewModel {
    public var locationInfo = LocationInfo()
    
    public func update(latitude: Double, longitude: Double, completed: ((String, String) -> Void)? = nil) {
        locationInfo = LocationInfo()
        
        Geocoder.fetchLocation(latitude: latitude, longitude: longitude, completed: { placemark in
            guard let city = placemark.locality,
                  let country = placemark.country,
                  let coordinates = placemark.location?.coordinate,
                  let timeZone = placemark.timeZone?.abbreviation()
            else { return }
            
            self.locationInfo.city = city
            self.locationInfo.country = country
            self.locationInfo.latitude = coordinates.latitude
            self.locationInfo.longitude = coordinates.longitude
            self.locationInfo.timeZone = timeZone
            
            Geocoder.fetchMapItems(latitude: latitude, longitude: longitude, query: "tourist attractions", completion: { items in
                self.locationInfo.touristAttractions = items
                
                guard let completed = completed else { return }
                completed(city, country)
            })
        })
    }
}
