//
//  POIView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-12-10.
//

import SwiftUI
import MapKit

struct POIView: View {
    public let touristAttractions: [MKMapItem]
    public let predefinedLocations: [SubLocationDTO]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                ForEach(touristAttractions, id: \.self) { result in
                    NavigationLink(destination: {
                        // TODO: Add a view to show this info.
                    }) {
                        if let name = result.name {
                            HStack {
                                VStack(alignment: .leading) {
                                    if let url = result.url {
                                        Link(
                                            name,
                                            destination: url
                                        )
                                        .multilineTextAlignment(.leading)
                                        .font(.headline)
                                    }
                                    else {
                                        Text(name)
                                            .multilineTextAlignment(.leading)
                                            .font(.headline)
                                    }
                                    
                                    if let phoneNumber = result.phoneNumber {
                                        Text(phoneNumber)
                                    }
                                }
                                
                                Spacer()
                                
                                // Show the image here.
                                LocationImageView(latitude: result.placemark.coordinate.latitude, longitude: result.placemark.coordinate.longitude)
                            }
                            
                            Spacer()
                        }
                    }
                    .buttonStyle(.plain)
                }
                
                ForEach(predefinedLocations) { location in
                    NavigationLink(destination: {
                        TouristAttractionView(location: location)
                    }) {
                        HStack {
                            VStack(alignment: .leading) {
                                Link(
                                    location.name,
                                    destination: URL(string: location.link)!
                                )
                                .multilineTextAlignment(.leading)
                                .font(.headline)
                                
                                Text(location.description)
                                    .multilineTextAlignment(.leading)
                            }
                            
                            Spacer()
                            
                            // Show the image here.
                            Image(location.imageNames[0])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 100, height: 100)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    POIView(
        touristAttractions: [],
        predefinedLocations: []
    )
}
