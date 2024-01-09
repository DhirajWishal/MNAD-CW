//
//  TouristAttractionsView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-28.
//

import SwiftUI
import MapKit

struct TouristAttractionsView: View {
    public let touristAttractions: [MKMapItem]
    public let predefinedLocations: [SubLocationDTO]
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if touristAttractions.isEmpty && predefinedLocations.isEmpty {
                    Text("Nothing to show here :(")
                } else {
                    POIView(
                        touristAttractions: touristAttractions,
                        predefinedLocations: predefinedLocations
                    )
                }
            }
            .navigationTitle("Tourist Attractions")
        }
        .padding()
        .onAppear {
            //            Geocoder.fetchMapItems(latitude: latitude, longitude: longitude, query: "tourist attractions", completion: { items in
            //                mapItems = items
            //            })
        }
    }
}

#Preview {
    TouristAttractionsView(
        touristAttractions: [],
        predefinedLocations: []
    )
}
