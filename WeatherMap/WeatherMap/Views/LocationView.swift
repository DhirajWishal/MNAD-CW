//
//  LocationView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI
import MapKit


struct LocationView: View {
    private let locationManager = LocationManager()
    private let model = LocationViewModel()
    
    private let updatedCallback: (Double, Double) -> Void
    
    @State private var searchString = ""
    @State private var searchPlaceholder = "City, Country"
    @State private var searchPredictions: [String] = []
    @State private var selectedSearchString = ""
    
    @State private var regionSpan = 0.1
    
    @State private var cameraPosition: MapCameraPosition = MapCameraPosition.automatic
    
//    // To get the user location.
//    @State var cameraPosition: MapCameraPosition = MapCameraPosition.userLocation(fallback: MapCameraPosition.automatic)
    
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    @State private var showMoreInfo = false
    @State private var showPrediction = false
    
    @FocusState private var isFocusedOnEditing: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    init(latitude: Double, longitude: Double, callback: @escaping (Double, Double) -> Void) {
        self.updatedCallback = callback
        self.latitude = latitude
        self.longitude = longitude
        
        updateLocation()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                MapReader { reader in
                    Map(position: $cameraPosition, interactionModes: .all) {
                        Annotation("", coordinate: getCenterCoordinate(coordinates: getCoordinates())) {
                            Image(systemName: "mappin").foregroundColor(.red)
                        }
                        
                        ForEach(model.locationInfo.touristAttractions, id: \.self) { item in
                            if let name = item.name {
                                if !item.isCurrentLocation {
                                    Marker(name, coordinate: item.placemark.coordinate)
                                } else {
                                    Marker(name, coordinate: getCoordinates())
                                }
                            }
                        }
                    }
                    .mapControls {
                            // To reolocate back to user.
                            MapUserLocationButton()
                            
                            // To switch from 2D to 3D
                            MapPitchToggle()
                    }
                    .onTapGesture { screenCoord in
                        onLocationTapped(coordinates: reader.convert(screenCoord, from: .local))
                    }
                    .onMapCameraChange { context in
                        print(context.camera.centerCoordinate)
                    }
                }
                
                VStack {
                    VStack {
                        HStack {
                            TextField(searchPlaceholder, text: $searchString)
                                .textFieldStyle(.roundedBorder)
                                .onChange(of: searchString, {
                                    Geocoder.addressCompletion(address: searchString, handler: onAddressCompletion)
                                })
                                .focused($isFocusedOnEditing)
                                .onSubmit {
                                    updateLocation()
                                    onReverseLocationSearch()
                                                                        
                                    showPrediction = false
                                }
                                .opacity(0.75)
                            
                            Button(action: {
                                onReverseLocationSearch()
                                
                                showPrediction = false
                            }, label: {
                                Image(systemName: "magnifyingglass")
                                    .bold()
                            })
                            .tint(.black)
                        }
                        
                        if isFocusedOnEditing && showPrediction {
                            List {
                                ForEach(searchPredictions, id: \.self) { prediction in
                                    Button(action: {
                                        searchString = prediction
                                        selectedSearchString = prediction
                                        
                                        updateLocation()
                                        onReverseLocationSearch()
                                        
                                        isFocusedOnEditing = false
                                    }, label: {
                                        Text(prediction)
                                    })
                                }
                            }
                            .listStyle(.plain)
                            .opacity(0.75)
                        }
                        
                        if !showMoreInfo {
                            Spacer()
                            
                            VStack {
                                HStack {
                                    Spacer()
                                    
                                    Button (action: {
                                        regionSpan -= regionSpan / 2
                                        updateCamera()
                                    }, label: {
                                        Image(systemName: "plus.magnifyingglass")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                    })
                                    .foregroundStyle(.black)
                                }
                                
                                HStack {
                                    Spacer()
                                    
                                    Button (action: {
                                        regionSpan += regionSpan / 2
                                        updateCamera()
                                    }, label: {
                                        Image(systemName: "minus.magnifyingglass")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 25, height: 25)
                                    })
                                    .foregroundStyle(.black)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    if showMoreInfo {
                        LocationInfoView(showMoreInfo: $showMoreInfo, locationInfo: model.locationInfo)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        updatedCallback(latitude, longitude)
                        dismiss()
                    }, label: {
                        Text("Done")
                            .frame(maxWidth: 150)
                    })
                }
            }
        }
        .onAppear {
            updateLocation()
            updateCamera()
        }
    }
    
    private func onLocationTapped(coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else { return }
        
        latitude = coordinates.latitude
        longitude = coordinates.longitude
        
        showLocationInfo()
    }
    
    private func showLocationInfo() {
        model.update(latitude: latitude, longitude: longitude, completed: { _, _ in
            withAnimation {
                showMoreInfo = true
            }
        })
    }
    
    private func getCoordinates() -> CLLocationCoordinate2D {
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
    
    private func updateCamera() {
        let region = MKCoordinateRegion(
            center: getCoordinates(),
            span: MKCoordinateSpan(latitudeDelta: regionSpan, longitudeDelta: regionSpan)
        )
        
        cameraPosition = MapCameraPosition.region(region)
    }
    
    private func updateLocation() {
        Geocoder.fetchLocation(latitude: latitude, longitude: longitude, completed: { city, country in
            searchPlaceholder = "\(city), \(country)"
            searchString = "\(city), \(country)"
        })
        
        showLocationInfo()
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
    
    private func onReverseLocationSearch() {
        Geocoder.fetchCoordinates(address: searchString, handler: { latitude, longitude in
            self.latitude = latitude
            self.longitude = longitude
            
            updateLocation()
            updateCamera()
            showLocationInfo()
        })
    }
    
    private func getCenterCoordinate(coordinates: CLLocationCoordinate2D?) -> CLLocationCoordinate2D {
        guard let coordinates = coordinates else {
            return getCoordinates()
        }
        
        return coordinates
    }
}

#Preview {
    LocationView(latitude: WeatherPresets.getDefaultLatitude(), longitude: WeatherPresets.getDefaultLongitude(), callback: { (lat, lon) in })
}
