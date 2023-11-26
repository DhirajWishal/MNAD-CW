//
//  ContentView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import SwiftUI

struct ContentView: View {
    @State var model = WeatherViewModel()
    
    @State var activeColorSet: [Color] = ContentView.getRandomGradient()
    @State var shouldRefresh = false
    
    @State var modelDataLoaded = false;
    @State var modelDataLoadedReady = false;
    
    var body: some View {
        VStack {
            if modelDataLoaded {
                WeatherView(model: model)
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
                                } else if model.isDataLoaded() {
                                    activeColorSet = WeatherPresets.getWeatherGradientColor(type: model.getSummary())
                                    
                                    modelDataLoadedReady = true
                                } else {
                                    activeColorSet = ContentView.getRandomGradient()
                                }
                            }
                        }
                    
                    VStack {
                        Text("Weather Map")
                            .font(.largeTitle)
                            .foregroundStyle(.black)
                            .bold()
                        
                        Spacer()
                        
                        ProgressView("Loading weather data...")
                        
                        Spacer()
                    }
                }
            }
        }
        .onAppear() {
            // Load data if we don't have any already.
            if !model.isDataLoaded() {
                // TODO: Access geolocation data and use that info.
                model.loadWeatherData(useDummy: false)
            }
            else {
                modelDataLoaded = true
                shouldRefresh = true
            }
        }
        .task {
            if shouldRefresh {
//                await model.refreshAsync()
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
