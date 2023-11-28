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
    
    @State var regionSpan = 0.1
    
    @State var placemarks = Dictionary<String, CLPlacemark>()
    @State var areasOfInterest: [String] = []
    
    @State var cameraPosition: MapCameraPosition = MapCameraPosition.automatic
    @State var latitude = ""
    @State var longitude = ""
    
    @State var showMoreInfo = false
    @State var showPrediction = false
    
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
                    
//                    self.latitude = String(format: "%.4f", context.camera.centerCoordinate.latitude)
//                    self.longitude = String(format: "%.4f", context.camera.centerCoordinate.longitude)
//                    
//                    updateLocation()
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
                                    
                                    showAreasOfInterest()
                                    
                                    showPrediction = false
                                }
                            
                            Button(action: {
                                onReverseLocationSearch()
                                showAreasOfInterest()
                                
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
                                        
                                        showAreasOfInterest()
                                    }, label: {
                                        Text(prediction)
                                    })
                                }
                            }
                            .listStyle(.plain)
                            .opacity(0.75)
                        }
                        
                        Spacer()
                        
                        if !showMoreInfo {
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
                        ZStack {
                            Color.white
                                                        
                            VStack {
                                VStack(alignment: .leading) {
                                    Text("Areas of Interest")
                                        .font(.title)
                                        .bold()
                                    
                                    List {
                                        ForEach(areasOfInterest, id: \.self) { interest in
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
    
    private func showAreasOfInterest() {
        areasOfInterest = getAreasOfInterest()
        
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 1 /* seconds */ * 1000 /* milliseconds */ * 1000 /* microseconds */ * 1000 /* nanoseconds */)
            
            withAnimation {
                showMoreInfo = !areasOfInterest.isEmpty
            }
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
            span: MKCoordinateSpan(latitudeDelta: regionSpan, longitudeDelta: regionSpan)
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
        
        showPrediction = !searchPredictions.isEmpty
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
