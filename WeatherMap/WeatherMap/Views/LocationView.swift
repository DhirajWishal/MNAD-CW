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
    
    @State var searchString = ""
    @State var searchPlaceholder = "City, Country"
    @State var searchPredictions: [String] = []
    @State var selectedSearchString = ""
    
    @State var placemarks = Dictionary<String, CLPlacemark>()
    
    @State var cameraPosition: MapCameraPosition = MapCameraPosition.automatic
    @State var latitude = ""
    @State var longitude = ""
    
    @State var showMoreInfo = false
    
    @FocusState var isFocusedOnEditing: Bool
    
    @Environment(\.dismiss) var dismiss
    
    init(latitude: String, longitude: String, callback: @escaping (String, String) -> Void) {
        self.updatedCallback = callback
        self.latitude = latitude
        self.longitude = longitude
        
        updateLocation()
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(position: $cameraPosition) {
                    Annotation("", coordinate: getCenterCoordinate(coordinates: getCoordinates())) {
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
                                    
                                    showMoreInfo = true
                                    
                                    searchPredictions = []
                                }
                            
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
                                        onReverseLocationSearch()
                                        
                                        isFocusedOnEditing = false
                                        
                                        withAnimation {
                                            showMoreInfo = true
                                        }
                                    }, label: {
                                        Text(prediction)
                                    })
                                }
                            }
                            .listStyle(.plain)
                            .opacity(0.75)
                        }
                        
                        Spacer()
                    }
                    .padding()
                    
                    if showMoreInfo {
                        ZStack {
                            Color.white
                            
                            VStack {
                                VStack(alignment: .leading) {
                                    Text("Areas of Interests")
                                        .font(.title)
                                        .bold()
                                    
                                    List {
                                        ForEach(getAreasOfInterest(), id: \.self) { interest in
                                            Text(interest)
                                        }
                                    }
                                    .listStyle(.plain)
                                }
                                
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
//                .padding()
            }
//            .toolbarBackground(
//                LinearGradient(colors: [.white, .white], startPoint: .top, endPoint: .bottom),
//                for: .automatic)
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
    
    private func getCoordinates() -> CLLocationCoordinate2D {
        guard let latitude = Double(latitude), let longitude = Double(longitude) else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        return CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
    }
    
    private func updateCamera() {
        let region = MKCoordinateRegion(
            center: getCoordinates(),
            span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        )
        
        cameraPosition = MapCameraPosition.region(region)
    }
    
    private func updateLocation() {
        Geocoder.fetchLocation(latitude: latitude, longitude: longitude, completed: { city, country in
            searchPlaceholder = "\(city), \(country)"
            searchString = "\(city), \(country)"
        })
    }
    
    private func onAddressCompletion(placemarks: [CLPlacemark]) {
        self.searchPredictions = []
        self.placemarks = Dictionary<String, CLPlacemark>()
        
        placemarks.forEach({ placemark in
            if let city = placemark.locality, let country = placemark.country {
                let prediction = "\(city), \(country)"
                
                self.searchPredictions.append(prediction)
                self.placemarks[prediction] = placemark
            }
        })
    }
    
    private func onReverseLocationSearch() {
        Geocoder.fetchCoordinates(address: searchString, handler: { latitude, longitude in
            self.latitude = latitude
            self.longitude = longitude
            
            updateLocation()
            updateCamera()
        })
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
    
    private func getAreasOfInterest() -> [String] {
        guard let placemark = placemarks[searchString], let interests = placemark.areasOfInterest else { return [] }
        return interests
    }
}

#Preview {
    LocationView(latitude: "51.5072", longitude: "0.1276", callback: { (lat, lon) in })
}
