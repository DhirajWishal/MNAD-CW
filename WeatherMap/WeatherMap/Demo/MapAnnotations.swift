//
//  MapAnnotations.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-12-01.
//

import SwiftUI
import MapKit

// DTO: Data Transfer Object
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

struct MapAnnotations: View {
    @State private var locations: [SubLocationDTO] = []
    
    var body: some View {
        VStack {
            if locations.isEmpty {
                Text("No locations")
            } else {
                Map {
                    ForEach(locations) { location in
                        Marker(location.name, coordinate: location.coordinate)
                    }
                }
            }
        }
        .onAppear {
            loadDataFromBundle()
        }
    }
    
    private func loadDataFromBundle() {
        guard let fileURL = Bundle.main.url(forResource: "MapData", withExtension: "json") else {
            print("Could not able to find the file")
            return
        }
         
        do {
            let rawData = try Data(contentsOf: fileURL)
            
            let decodedData = try JSONDecoder().decode(MainLocationDTO.self, from: rawData)
            
            print(decodedData.locations[0].name)
            print(decodedData.locations[1].name)
            locations = decodedData.locations
        } catch {
            print("Failed to decode the data.")
        }
    }
}

#Preview {
    MapAnnotations()
}
