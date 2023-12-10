//
//  WeatherTopView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct WeatherTopView: View {
    public var model: WeatherViewModel
    
    @Binding public var shouldShowLocationSearch: Bool
    
    @State private var isLocationAvailable = false
    @State private var cityName = ""
    @State private var countryName = ""
    
    @State private var showAreasOfInterest = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    if isLocationAvailable {
                        Button(action: {
                            showAreasOfInterest = true
                        }, label: {
                            VStack(alignment: .leading) {
                                HStack {
                                    Text(cityName)
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .multilineTextAlignment(.leading)
                                        .bold()
                                    
                                    Image(systemName: "arrow.up.forward.app")
                                }
                                
                                Text(countryName)
                                    .font(.title2)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                    .bold()
                            }
                        })
                        .tint(.white)
                    } else {
                        ProgressView()
                            .tint(.white)
                    }
                    
                    Spacer()
                    
                    // Go to the location view if necessary.
                    Button(action: {
                        shouldShowLocationSearch = true
                    }, label: {
                        Image(systemName: "map.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .tint(.white)
                    })
                }
                
                Text(model.getDateTime())
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
            }
        }
        .onAppear() {
            Geocoder.fetchLocation(latitude: model.getLatitude(), longitude: model.getLongitude(), completed: onLocationNameFetched)
        }
        .navigationDestination(isPresented: $showAreasOfInterest) {
            TouristAttractionsView(latitude: model.getLatitude(), longitude: model.getLongitude())
        }
    }
    
    private func onLocationNameFetched(city: String, country: String) {
        cityName = city
        countryName = country
        isLocationAvailable = true
    }
}

#Preview {
    WeatherTopView(model: WeatherViewModel(), shouldShowLocationSearch: .constant(false))
}
