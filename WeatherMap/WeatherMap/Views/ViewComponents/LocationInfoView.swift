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
    @Binding var showMoreInfo: Bool
    
    var locationInfo: LocationInfo
    
    @State private var searchResults: [MKMapItem] = []
    
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
                    
                    if !searchResults.isEmpty {
                        ScrollView(showsIndicators: false) {
                            List {
                                //                            ForEach(locationInfo.areasOfInterest, id: \.self) { area in
                                //                                Text(area)
                                //                            }
                                
                                ForEach(searchResults, id: \.self) { result in
                                    Text(result.name ?? "")
                                        .multilineTextAlignment(.center)
                                    Text(result.phoneNumber ?? "")
                                    
                                    Spacer()
                                    
                                    Text("Helloo")
                                }
                            }
                            .listStyle(.plain)
                        }
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
        .onAppear {
            requestAdditionalInfo()
        }
    }
    
    private func requestAdditionalInfo() {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "landmarks"
        request.resultTypes = .pointOfInterest
        request.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: locationInfo.latitude, longitude: locationInfo.longitude),
            span: MKCoordinateSpan (latitudeDelta: 0.0125, longitudeDelta: 0.0125)
        )
        
        Task {
            let search = MKLocalSearch(request: request)
            let response = try? await search.start()
            searchResults = response?.mapItems ?? []
        }
    }
}

#Preview {
    LocationInfoView(showMoreInfo: .constant(true), locationInfo: LocationInfo(city: "London", country: "United Kingdom"))
}
