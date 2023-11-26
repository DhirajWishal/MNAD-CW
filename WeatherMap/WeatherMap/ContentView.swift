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
    
    var body: some View {
        VStack {
            if model.isDataLoaded() {
                WeatherView(model: model)
            }
            else {
                // Inform the user that we're loading with a changing gradient.
                ZStack {
                    LinearGradient(colors: activeColorSet, startPoint: .top, endPoint: .bottom)
                        .ignoresSafeArea()
                        .onAppear() {
                            withAnimation(.linear(duration: 5.0).repeatForever(autoreverses: true)) {
                                activeColorSet = ContentView.getRandomGradient()
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
                shouldRefresh = true
            }
        }
        .task {
            if shouldRefresh {
                await model.refreshAsync()
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
