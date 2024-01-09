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
    private let model: LocationViewModel
    
    private let updatedCallback: (Double, Double) -> Void
    
    @State private var regionSpan = 0.1
    
    @State private var cameraPosition: MapCameraPosition = MapCameraPosition.automatic
    
    // To get the user location.
//    @State var cameraPosition: MapCameraPosition = MapCameraPosition.userLocation(fallback: MapCameraPosition.automatic)
    
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    @State private var showMoreInfo = false
    @State private var showSearch = false
    @State private var showTouristAttractions = false
    
    @Environment(\.dismiss) private var dismiss
    
    init(model: LocationViewModel, callback: @escaping (Double, Double) -> Void) {
        self.model = model
        self.updatedCallback = callback
        self.latitude = model.locationInfo.latitude
        self.longitude = model.locationInfo.longitude
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
                        
                        ForEach(model.getFilteredPredefinedLocations()) { location in
                            Marker(location.name, coordinate: location.coordinate)
                        }
                    }
                    .mapControls {
                        // To reolocate back to user.
                        MapUserLocationButton()
                        
                        // To switch from 2D to 3D
                        MapPitchToggle()
                        
                        // Show the compass.
                        MapCompass()
                    }
                    // TODO: Add this back with a proper input system.
                    //                    .onTapGesture { screenCoord in
                    //                        onLocationTapped(coordinates: reader.convert(screenCoord, from: .local))
                    //                    }
                    .onMapCameraChange { context in
                        print(context.camera.centerCoordinate)
                    }
                }
                
                VStack {
                    VStack {
                        if !showSearch && !showMoreInfo {
                            HStack {
                                ZStack {
                                    Color.white
                                    
                                    Button(action: {
                                        withAnimation {
                                            showSearch = true
                                        }
                                    }, label: {
                                        Image(systemName: "magnifyingglass")
                                            .bold()
                                    })
                                }
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .background(RoundedRectangle(cornerRadius: 25.0).shadow(radius: 10))
                                .frame(width: 50, height: 50)
                                
                                Spacer()
                            }
                            
                            Spacer()
                            
                            VStack {
                                Button(action: {
                                    showTouristAttractions = true
                                }, label: {
                                    Text("Tourist attractions")
                                    Image(systemName: "arrow.up.forward.app")
                                })
                                .buttonStyle(.bordered)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .background(RoundedRectangle(cornerRadius: 25.0).fill(.white))
                            }
//                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
//                            .background(RoundedRectangle(cornerRadius: 25.0).fill(.white).shadow(radius: 10))
                        }
                        
                        if showSearch {
                            LocationSearchView(latitude: self.latitude, longitude: self.longitude, updateLocation: self.updateLocation,
                                               onReverseLocationSearch: self.onReverseLocationSearch)
                        }
                    }
                    .padding()
                    
                    if showMoreInfo {
                        LocationInfoView(showMoreInfo: $showMoreInfo, model: model)
                    }
                    
                    Spacer()
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
            self.latitude = model.locationInfo.latitude
            self.longitude = model.locationInfo.longitude
            
            updateCamera()
        }
        .navigationDestination(isPresented: $showTouristAttractions) {
            TouristAttractionsView(model: model)
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
        showLocationInfo()
    }
    
    private func onReverseLocationSearch(searchString: String) {
        Geocoder.fetchCoordinates(address: searchString, handler: { latitude, longitude in
            self.latitude = latitude
            self.longitude = longitude
            
            updateLocation()
            updateCamera()
            showLocationInfo()
        })
        
        withAnimation {
            showSearch = false
        }
    }
    
    private func getCenterCoordinate(coordinates: CLLocationCoordinate2D?) -> CLLocationCoordinate2D {
        guard let coordinates = coordinates else {
            return getCoordinates()
        }
        
        return coordinates
    }
}

#Preview {
    LocationView(
        model: LocationViewModel(),
        callback: { (lat, lon) in }
    )
}
