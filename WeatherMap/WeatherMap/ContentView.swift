//
//  ContentView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import SwiftUI

struct ContentView: View {
    @State var model = WeatherViewModel()
    
    @State var main = "Loading..."
    @State var description = ""
    
    var body: some View {
        VStack {
            if model.isDataLoaded() {
                WeatherView(model: model)
            }
            else {
                ProgressView()
            }
        }
        .onAppear() {
            // TODO: Access geolocation data and use that info.
            model.loadWeatherData(latitude: "0", longitude: "0", useDummy: false)
        }
    }
}

#Preview {
    ContentView()
}
