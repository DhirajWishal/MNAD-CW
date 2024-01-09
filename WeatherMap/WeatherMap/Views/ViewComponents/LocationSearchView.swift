//
//  LocationSearchView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2024-01-08.
//

import SwiftUI
import CoreLocation

struct LocationSearchView: View {
    @State private var searchString = ""
    @State private var searchPlaceholder = "City, Country"
    @State private var searchPredictions: [String] = []
    @State private var selectedSearchString = ""
    
    @State private var showPrediction = false
    
    @FocusState private var isFocusedOnEditing: Bool
    
    @State private var onReverseLocationSearch: (String) -> Void
    
    init(latitude: Double, longitude: Double, onReverseLocationSearch: @escaping (String) -> Void) {
        self.onReverseLocationSearch = onReverseLocationSearch
        
        self.initialize(latitude: latitude, longitude: longitude)
    }
    
    var body: some View {
        VStack {
            HStack {
                TextField(searchPlaceholder, text: $searchString)
                    .textFieldStyle(.roundedBorder)
                    .onChange(of: searchString, {
                        Geocoder.addressCompletion(address: searchString, handler: onAddressCompletion)
                    })
                    .focused($isFocusedOnEditing)
                    .onSubmit {
                        onReverseLocationSearch(searchString)
                        
                        showPrediction = false
                    }
                
                Button(action: {
                    onReverseLocationSearch(searchString)
                    
                    showPrediction = false
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .bold()
                })
            }
            .padding()
            
            if isFocusedOnEditing && showPrediction {
                List {
                    ForEach(searchPredictions, id: \.self) { prediction in
                        Button(action: {
                            searchString = prediction
                            selectedSearchString = prediction
                            
                            onReverseLocationSearch(searchString)
                            
                            isFocusedOnEditing = false
                        }, label: {
                            Text(prediction)
                        })
                    }
                }
                .listStyle(.plain)
            }
            else {
                Spacer()
            }
        }
        //        .transition(.move(edge: .bottom))
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .background(RoundedRectangle(cornerRadius: 25.0).fill(.white).shadow(radius: 10))
        .frame(height: 200)
        .padding()
    }
    
    private func initialize(latitude: Double, longitude: Double) {
        Geocoder.fetchLocation(latitude: latitude, longitude: longitude, completed: { city, country in
            self.searchPlaceholder = "\(city), \(country)"
            self.searchString = "\(city), \(country)"
        })
    }
    
    private func onAddressCompletion(placemarks: [CLPlacemark]) {
        self.searchPredictions = []
        
        placemarks.forEach({ placemark in
            if let city = placemark.locality, let country = placemark.country {
                let prediction = "\(city), \(country)"
                
                self.searchPredictions.append(prediction)
            }
        })
        
        showPrediction = !searchPredictions.isEmpty
    }
}

#Preview {
    LocationSearchView(
        latitude: WeatherPresets.getDefaultLatitude(),
        longitude: WeatherPresets.getDefaultLongitude(),
        onReverseLocationSearch: { searchString in }
    )
}
