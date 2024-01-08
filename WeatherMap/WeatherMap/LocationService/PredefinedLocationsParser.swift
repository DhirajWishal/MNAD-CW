//
//  PredefinedLocationsParser.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2024-01-08.
//

import Foundation
import Observation
import CoreLocation

struct MainLocationDTO: Codable {
    let locations: [SubLocationDTO]
}

struct SubLocationDTO: Codable, Identifiable {
    let id = UUID().uuidString
    
    let name: String
    let cityName: String
    let longitude: Double
    let latitude: Double
    let description: String
    let imageNames: [String]
    let link: String
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

@Observable class PredefinedLocationsParser {
    private var predefinedLocations: [SubLocationDTO] = []
    
    init(filename: String = "PredefinedLocations")
    {
        guard let fileURL = Bundle.main.url(forResource: filename, withExtension: "json") else {
            print("Could not able to find the file")
            return
        }
        
        do {
            let rawData = try Data(contentsOf: fileURL)
            
            let decodedData = try JSONDecoder().decode(MainLocationDTO.self, from: rawData)
            
            print(decodedData.locations[0].name)
            print(decodedData.locations[1].name)
            predefinedLocations = decodedData.locations
        } catch {
            print("Failed to decode the data.")
        }
    }
    
    public func getLocations() -> [SubLocationDTO] {
        return predefinedLocations
    }
    
    public func getFilteredLocations(cityName: String) -> [SubLocationDTO] {
        return predefinedLocations.filter({ return $0.cityName == cityName })
    }
}
