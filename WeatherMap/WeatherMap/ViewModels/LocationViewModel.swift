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
    private let predefinedLocationsParser = PredefinedLocationsParser()
    
    init() {
        loadData()
    }
    
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
                // TODO: Add this back after adding a proper method to get a location preview.
                // self.locationInfo.touristAttractions = items
                
                // Save the data.
                self.saveData()
                
                guard let completed = completed else { return }
                completed(city, country)
            })
        })
    }
    
    public func getPredefinedLocations() -> [SubLocationDTO] {
        return predefinedLocationsParser.getLocations()
    }
    
    public func getFilteredPredefinedLocations() -> [SubLocationDTO] {
        return predefinedLocationsParser.getFilteredLocations(cityName: locationInfo.city)
    }
    
    // Save data to local storage.
    public func saveData() {
        if let encodedData = try? JSONEncoder().encode(locationInfo.getDTO()) {
            UserDefaults.standard.set(encodedData, forKey: "WeatherMap_LocationData")
        }
    }
    
    // Load data from local storage.
    public func loadData() {
        let data = UserDefaults.standard.data(forKey: "WeatherMap_LocationData")
        if let unwrappedData = data, let decodedData = try? JSONDecoder().decode(LocationInfoDTO.self, from: unwrappedData) {
            locationInfo.fromDTO(dto: decodedData)
            
            // Update and get the tourist attractions.
            update(latitude: locationInfo.latitude, longitude: locationInfo.longitude)
        }
    }
}
