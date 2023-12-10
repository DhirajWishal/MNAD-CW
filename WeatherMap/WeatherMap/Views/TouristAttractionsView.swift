//
//  TouristAttractionsView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-28.
//

import SwiftUI
import MapKit

struct TouristAttractionsView: View {
    public let latitude: Double
    public let longitude: Double
    
    @State private var mapItems: [MKMapItem] = []

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                POIView(mapItems: mapItems)
            }
            .navigationTitle("Tourist Attractions")
        }
        .padding()
        .onAppear {
            Geocoder.fetchMapItems(latitude: latitude, longitude: longitude, query: "tourist attractions", completion: { items in
                mapItems = items
            })
        }
    }
}

#Preview {
    TouristAttractionsView(latitude: WeatherPresets.getDefaultLatitude(), longitude: WeatherPresets.getDefaultLongitude())
}
