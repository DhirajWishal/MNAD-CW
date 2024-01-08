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
    
    public let model: LocationViewModel
    
    var body: some View {
        ZStack {
            Color.white
            
            VStack {
                VStack(alignment: .leading) {
                    Text(model.locationInfo.city)
                        .font(.title)
                        .bold()
                    
                    Text("(\(model.locationInfo.latitude), \(model.locationInfo.longitude))")
                        .foregroundStyle(.gray)
                    
                    Text(model.locationInfo.country)
                    
                    if !model.locationInfo.touristAttractions.isEmpty || !model.getFilteredPredefinedLocations().isEmpty {
                        POIView(model: model)
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
    LocationInfoView(
        showMoreInfo: .constant(true),
        model: LocationViewModel()
    )
}
