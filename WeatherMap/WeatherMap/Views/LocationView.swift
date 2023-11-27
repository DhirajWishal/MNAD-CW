//
//  LocationView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI
import MapKit


struct LocationView: View {
    let locationManager = LocationManager()
    
    let updatedCallback: (String, String) -> Void
    
    @State var searchString = "" {
        didSet {
            Geocoder.addressCompletion(address: searchString, handler: onAddressCompletion)
        }
    }
    @State var searchPlaceholder = "City, Country"
    @State var searchPredictions: [String] = []
    @State var selectedSearchString = ""
    
    @State var cameraPosition: MapCameraPosition = MapCameraPosition.automatic
    @State var latitude = ""
    @State var longitude = ""
    
    @FocusState var isFocusedOnEditing: Bool
    
    @Environment(\.dismiss) var dismiss
    
    init(latitude: String, longitude: String, callback: @escaping (String, String) -> Void) {
        self.updatedCallback = callback
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $cameraPosition) {
                    Annotation("", coordinate: getCenterCoordinate(coordinates: cameraPosition.camera?.centerCoordinate)) {
                        Image(systemName: "mappin").foregroundColor(.red)
                    }
                }
                .onMapCameraChange { context in
                    print(context.camera.centerCoordinate)
                    
                    self.latitude = String(format: "%.4f", context.camera.centerCoordinate.latitude)
                    self.longitude = String(format: "%.4f", context.camera.centerCoordinate.longitude)
                    
                    updateLocation()
                }
                
                VStack {
                    HStack {
                        TextField(searchPlaceholder, text: $searchString)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: searchString, {
                                Geocoder.addressCompletion(address: searchString, handler: onAddressCompletion)
                            })
                            .focused($isFocusedOnEditing)
                        
                        Button(action: {
                            onReverseLocationSearch()
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .bold()
                        })
                        .tint(.black)
                    }
                    
                    if selectedSearchString != searchString && !searchPredictions.isEmpty {
                        List {
                            ForEach(searchPredictions, id: \.self) { prediction in
                                Button(action: {
                                    searchString = prediction
                                    selectedSearchString = prediction
                                    
                                    updateLocation()
                                    updateCamera()
                                    
                                    isFocusedOnEditing = false
                                }, label: {
                                    Text(prediction)
                                })
                            }
                        }
                        .listStyle(.plain)
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .toolbarBackground(.automatic, for: .automatic)
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem {
                Button("Done", action: {
                    dismiss()
                })
            }
        }
        .onAppear {
            updateLocation()
            updateCamera()
        }
    }
    
    private func updateCamera() {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else { return }
        
        let coordinates = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            ),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        
        self.cameraPosition = MapCameraPosition.region(coordinates)
    }
    
    private func updateLocation() {
        Geocoder.fetchLocation(latitude: latitude, longitude: longitude, completed: { city, country in
            searchPlaceholder = "\(city), \(country)"
        })
    }
    
    private func onAddressCompletion(placemarks: [CLPlacemark]) {
        searchPredictions = []
        
        placemarks.forEach({ placemark in
            if let city = placemark.locality, let country = placemark.country {
                searchPredictions.append("\(city), \(country)")
            }
        })
    }
    
    private func onReverseLocationSearch() {
        Geocoder.fetchCoordinates(address: searchString, handler: { latitude, longitude in
            self.latitude = latitude
            self.longitude = longitude
        })
        
        updateLocation()
        updateCamera()
    }
    
    private func getCenterCoordinate(coordinates: CLLocationCoordinate2D?) -> CLLocationCoordinate2D {
        guard let coordinates = coordinates else {
            guard let latitude = Double(latitude), let longitude = Double(longitude) else {
                return CLLocationCoordinate2D(
                    latitude: 0,
                    longitude: 0
                )
            }
            
            return CLLocationCoordinate2D(
                latitude: latitude,
                longitude: longitude
            )
        }
        return coordinates
    }
}

#Preview {
    LocationView(latitude: "51.5072", longitude: "0.1276", callback: { (lat, lon) in })
}
