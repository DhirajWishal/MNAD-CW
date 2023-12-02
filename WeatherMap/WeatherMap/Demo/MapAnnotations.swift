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
    @State private var searchResults: [MKMapItem] = []
    
    @State private var shouldShowDescription = false
    
    var body: some View {
        VStack {
            if locations.isEmpty {
                Text("No locations")
            } else {
                ZStack {
                    Map {
                        ForEach(locations) { location in
                            Marker(location.name, coordinate: location.coordinate)
                        }
                    }
                    
                    if shouldShowDescription {
                        VStack {
                            ScrollView(showsIndicators: false) {
                                ForEach(searchResults, id: \.self) { result in
                                    Text(result.name ?? "")
                                        .multilineTextAlignment(.center)
                                    Text(result.phoneNumber ?? "")
                                    
                                    Spacer()
                                }
                            }
                            .frame(width: UIScreen.main.bounds.width)
                            
                            Spacer()
                            
                            Button("Close", action: {
                                withAnimation {
                                    shouldShowDescription = false
                                }
                            })
                        }
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                        .transition(.move(edge: .bottom))
                    }
                }
            }
        }
        .onAppear {
            loadDataFromBundle()
            
            let request = MKLocalSearch.Request()
            request.naturalLanguageQuery = "landmarks"
            request.resultTypes = .pointOfInterest
            request.region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
                span: MKCoordinateSpan (latitudeDelta: 0.0125, longitudeDelta: 0.0125)
            )
            
            Task {
                let search = MKLocalSearch(request: request)
                let response = try? await search.start()
                searchResults = response?.mapItems ?? []
                
                if !searchResults.isEmpty {
                    Task {
                        await try? Task.sleep(nanoseconds: 1 * 1000 * 1000 * 1000)
                        withAnimation {
                            shouldShowDescription = true
                        }
                    }
                }
            }
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
