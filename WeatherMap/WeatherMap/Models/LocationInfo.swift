//
//  LocationInfo.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-29.
//

import Foundation
import Observation

@Observable class LocationInfo {
    var city = ""
    var country = ""
    var timeZone = ""
    var areasOfInterest: [String] = []
    
    var latitude = WeatherPresets.getDefaultLatitude()
    var longitude = WeatherPresets.getDefaultLongitude()
    
    init(city: String = "", country: String = "", latitude: Double = WeatherPresets.getDefaultLatitude(), longitude: Double = WeatherPresets.getDefaultLongitude()) {
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
}
