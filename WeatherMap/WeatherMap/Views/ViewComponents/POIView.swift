//
//  POIView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-12-10.
//

import SwiftUI
import MapKit

struct POIView: View {    
    public let model: LocationViewModel
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(model.locationInfo.touristAttractions, id: \.self) { result in
                if let name = result.name {
                    HStack {
                        VStack(alignment: .leading) {
                            if let url = result.url {
                                Button(action: {
                                    // Go-to link.
                                }, label: {
                                    Text(name)
                                        .multilineTextAlignment(.leading)
                                        .font(.headline)
                                })
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
            
            ForEach(model.getFilteredPredefinedLocations()) { location in
                HStack {
                    VStack(alignment: .leading) {
                        Button(action: {
                            // Go-to link.
                        }, label: {
                            Text(location.name)
                                .multilineTextAlignment(.leading)
                                .font(.headline)
                        })
                        
                        Text(location.description)
                    }
                    
                    Spacer()
                    
                    // Show the image here.
                    Image(location.imageNames[0])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                }
            }
        }
    }
}

#Preview {
    POIView(model: LocationViewModel())
}
