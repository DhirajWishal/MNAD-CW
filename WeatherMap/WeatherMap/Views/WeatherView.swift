//
//  WeatherView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import SwiftUI

struct WeatherView: View {
    var model: WeatherViewModel
    
    @State var shouldShowLocationSearch = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment:.leading) {
                // Set the background color.
                LinearGradient(
                    //                colors: model.getGradientColors(override: "Thunderstorm"),
                    //                colors: model.getGradientColors(override: "Drizzle"),
                    //                colors: model.getGradientColors(override: "Rain"),
                    colors: model.getGradientColors(override: "Snow"),
                    //                                colors: model.getGradientColors(override: "Atmosphere"),
                    //                                colors: model.getGradientColors(override: "Clear"),
                    //                                colors: model.getGradientColors(override: "Clouds"),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main content stack.
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        // Show the location information and time.
                        WeatherTopView(model: model, shouldShowLocationSearch: $shouldShowLocationSearch)
                        
                        // Show the temperature information
                        WeatherTemperatureView(model: model)
                        
                        // Show the other information.
                        WeatherCardView(model: model)
                        
                        // Show the source to the user.
                        WeatherSourceView()
                        
                        // Show today's forecast hourly
                        WeatherHourlyView(model: model)
                        
                        // Show the daily forcast.
                        WeatherDailyView(model: model)
                    }
                }
                .padding()
                .refreshable {
                    // Refresh the weather data.
                    await model.refresh()
                }
                .navigationDestination(isPresented: $shouldShowLocationSearch) {
                    LocationView()
                }
            }
        }
    }
}

#Preview {
    WeatherView(model: WeatherViewModel(dummyDataRequired: true))
}
