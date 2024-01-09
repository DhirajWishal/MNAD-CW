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
    
    @State private var locationInfo = LocationInfo()
    
    @State private var latitude = 0.0
    @State private var longitude = 0.0
    
    @State private var showMoreInfo = false
    @State private var showSearch = false
    @State private var showTouristAttractions = false
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) private var colorScheme
    
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
                                Button(action: {
                                    withAnimation {
                                        showSearch = true
                                    }
                                }, label: {
                                    Image(systemName: "magnifyingglass")
                                        .bold()
                                })
                                .buttonStyle(.bordered)
                                .clipShape(RoundedRectangle(cornerRadius: 25.0))
                                .background(content: {
                                    if colorScheme == .dark {
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .fill(.black)
                                            .shadow(radius: 10)
                                    } else {
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .fill(.white)
                                            .shadow(radius: 10)
                                    }
                                })
                                
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
                                .background(content: {
                                    if colorScheme == .dark {
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .fill(.black)
                                            .shadow(radius: 10)
                                    } else {
                                        RoundedRectangle(cornerRadius: 25.0)
                                            .fill(.white)
                                            .shadow(radius: 10)
                                    }
                                })
                            }
                        }
                        
                        if showSearch {
                            LocationSearchView(latitude: self.latitude, longitude: self.longitude,
                                               onReverseLocationSearch: self.onReverseLocationSearch)
                        }
                    }
                    .padding()
                    
                    if showMoreInfo {
                        LocationInfoView(
                            showMoreInfo: $showMoreInfo,
                            locationInfo: locationInfo
                        )
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem {
                    Button(action: {
                        updateLocation()
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
            self.locationInfo = model.locationInfo
            self.latitude = model.locationInfo.latitude
            self.longitude = model.locationInfo.longitude
            
            updateCamera()
        }
        .navigationDestination(isPresented: $showTouristAttractions) {
            TouristAttractionsView(
                touristAttractions: locationInfo.touristAttractions,
                predefinedLocations: model.getFilteredPredefinedLocations()
            )
        }
    }
    
    private func onLocationTapped(coordinates: CLLocationCoordinate2D?) {
        guard let coordinates = coordinates else { return }
        
        latitude = coordinates.latitude
        longitude = coordinates.longitude
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
        model.update(latitude: latitude, longitude: longitude, completed: { _, _ in
            withAnimation {
                showMoreInfo = true
            }
        })
    }
    
    private func onReverseLocationSearch(searchString: String) {
        Geocoder.fetchCoordinates(address: searchString, handler: { latitude, longitude in
            self.latitude = latitude
            self.longitude = longitude
            
            updateCamera()
            
            Geocoder.fetchLocation(
                latitude: latitude,
                longitude: longitude,
                completed: { placemark in
                    guard let city = placemark.locality,
                          let country = placemark.country,
                          let coordinates = placemark.location?.coordinate,
                          let timeZone = placemark.timeZone?.abbreviation()
                    else { return }
                    
                    self.locationInfo.city = city
                    self.locationInfo.country = country
                    self.locationInfo.latitude = coordinates.latitude
                    self.locationInfo.longitude = coordinates.longitude
                    self.locationInfo.timeZone = timeZone
                    
                    withAnimation {
                        showMoreInfo = true
                    }
                }
            )
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
