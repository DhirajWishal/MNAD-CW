//
//  LocationInfoView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-29.
//

import SwiftUI
import CoreLocation
import MapKit

struct LocationInfoView: View {
    @Binding public var showMoreInfo: Bool
    
    public let locationInfo: LocationInfo
        
    var body: some View {
        ZStack {
            Color.white
            
            VStack {
                VStack(alignment: .leading) {
                    Text(locationInfo.city)
                        .font(.title)
                        .bold()
                    
                    Text("(\(locationInfo.latitude), \(locationInfo.longitude))")
                        .foregroundStyle(.gray)
                    
                    Text(locationInfo.country)
                    
                    if !locationInfo.touristAttractions.isEmpty {
                        POIView(mapItems: locationInfo.touristAttractions)
                    } else {
                        Spacer()
                    }
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
    LocationInfoView(showMoreInfo: .constant(true), locationInfo: LocationInfo(city: "London", country: "United Kingdom"))
}
