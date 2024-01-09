//
//  TouristAttractionsView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-28.
//

import SwiftUI
import MapKit

struct TouristAttractionsView: View {
    public let model: LocationViewModel

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                if model.getFilteredPredefinedLocations().isEmpty {
                    Text("Nothing to show here :(")
                } else {
                    POIView(model: model)
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
    TouristAttractionsView(model: LocationViewModel())
}
