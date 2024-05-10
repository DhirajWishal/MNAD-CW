//
//  ContentView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import SwiftUI

struct ContentView: View {
    @State var weatherViewModel = WeatherViewModel()
    @State var locationViewModel = LocationViewModel()
    
    @State var activeColorSet: [Color] = ContentView.getRandomGradient()
    @State var shouldRefresh = false
    
    @State var modelDataLoaded = false;
    @State var modelDataLoadedReady = false;
    
    var body: some View {
        VStack {
            if modelDataLoaded {
                WeatherView(model: weatherViewModel, locationViewModel: locationViewModel)
            } else {
                // Inform the user that we're loading with a changing gradient.
                ZStack {
                    LinearGradient(colors: activeColorSet, startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                        .onAppear() {
                            withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                                // This mechanism attempts to smoothen out the transition between random
                                // color gradients to weather color gradient.
                                if modelDataLoadedReady {
                                    modelDataLoaded = true
                                } else if weatherViewModel.isDataLoaded() {
                                    activeColorSet = WeatherPresets.getWeatherGradientColor(type: weatherViewModel.getSummary())
                                    
                                    modelDataLoadedReady = true
                                } else {
                                    activeColorSet = ContentView.getRandomGradient()
                                }
                            }
                        }
                    
                    VStack {
                        Text("Weather Map")
                            .font(.largeTitle)
                            .foregroundStyle(.white.opacity(0.75))
                            .bold()
                        
                        Spacer()
                        
                        ProgressView("Loading weather data...")
                            .tint(.white)
                            .foregroundStyle(.white)
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear() {
            // Load data if we don't have any already.
            if weatherViewModel.isDataLoaded() {
                modelDataLoaded = true
                shouldRefresh = true
            } else {
                weatherViewModel.refresh()
                modelDataLoaded = true
            }
            
            // Initialize the location view model.
            locationViewModel.update(
                latitude: weatherViewModel.getLatitude(),
                longitude: weatherViewModel.getLongitude()
            )
        }
        .task {
            if shouldRefresh {
                await weatherViewModel.refreshAsync()
                modelDataLoaded = true
                shouldRefresh = false
            }
        }
    }
    
    private static func getRandomGradient() -> [Color] {
        return WeatherPresets.getWeatherGradientColor(type: WeatherType.allCases.randomElement() ?? WeatherType.Atmosphere)
    }
}

#Preview {
    ContentView()
}
