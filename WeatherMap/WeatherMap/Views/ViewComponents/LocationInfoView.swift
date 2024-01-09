//
//  LocationInfoView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-29.
//

import SwiftUI


struct LocationInfoView: View {
    private let predefinedLocations = PredefinedLocationsParser()
    
    @Binding public var showMoreInfo: Bool
    public let locationInfo: LocationInfo
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text(locationInfo.city)
                            .font(.title)
                            .bold()
                        
                        Text("(\(locationInfo.latitude), \(locationInfo.longitude))")
                            .foregroundStyle(.gray)
                        
                        Text(locationInfo.country)
                            .bold()
                    }
                    
                    Spacer()
                }
                
                if !locationInfo.touristAttractions.isEmpty || !predefinedLocations.getFilteredLocations(cityName: locationInfo.city).isEmpty {
                    POIView(
                        touristAttractions: locationInfo.touristAttractions,
                        predefinedLocations: predefinedLocations.getFilteredLocations(cityName: locationInfo.city)
                    )
                }
                
                Spacer()
                
                Button(action: {
                    withAnimation {
                        showMoreInfo = false
                    }
                }, label: {
                    Text("Okay")
                        .frame(minWidth: 150)
                })
                .buttonStyle(.bordered)
            }
            .padding()
        }
        .transition(.move(edge: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .background(RoundedRectangle(cornerRadius: 25.0).shadow(radius: 10))
        .padding()
    }
}

#Preview {
    LocationInfoView(
        showMoreInfo: .constant(true),
        locationInfo: LocationInfo()
    )
}
