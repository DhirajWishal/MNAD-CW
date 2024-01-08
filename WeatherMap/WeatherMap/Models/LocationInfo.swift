//
//  LocationInfo.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-29.
//

import Foundation
import Observation
import MapKit

struct LocationInfoDTO: Codable {
    let city: String
    let country: String
    let timeZone: String
    
    let latitude: Double
    let longitude: Double
}

@Observable class LocationInfo {
    var city = ""
    var country = ""
    var timeZone = ""
    var touristAttractions: [MKMapItem] = []
    
    var latitude = WeatherPresets.getDefaultLatitude()
    var longitude = WeatherPresets.getDefaultLongitude()
    
    init(city: String = "", country: String = "", latitude: Double = WeatherPresets.getDefaultLatitude(), longitude: Double = WeatherPresets.getDefaultLongitude()) {
        self.city = city
        self.country = country
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public func getDTO() -> LocationInfoDTO {
        return LocationInfoDTO(
            city: city,
            country: country,
            timeZone: timeZone,
            latitude: latitude,
            longitude: longitude
        )
    }
    
    public func fromDTO(dto: LocationInfoDTO) {
        self.city = dto.city
        self.country = dto.country
        self.timeZone = dto.timeZone
        self.latitude = dto.latitude
        self.longitude = dto.longitude
    }
}
