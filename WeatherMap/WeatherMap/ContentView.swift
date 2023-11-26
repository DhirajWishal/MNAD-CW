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
            // TODO: Access geolocation data and use that info.
             model.loadWeatherData(latitude: "6.9271", longitude: "79.8612", useDummy: true)
        }
    }
    
    private static func getRandomGradient() -> [Color] {
        return WeatherPresets.getWeatherGradientColor(type: WeatherTypes.allCases.randomElement() ?? WeatherTypes.Atmosphere)
    }
}

#Preview {
    ContentView()
}
