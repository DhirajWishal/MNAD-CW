//
//  WeatherView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import SwiftUI

struct WeatherView: View {
    public var model: WeatherViewModel
    public var locationViewModel: LocationViewModel
    
    @State private var shouldShowLocationSearch = false
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .leading) {
                // Set the background color.
                // TODO: Switch themes depending on the time.
                LinearGradient(
                    colors: model.getGradientColors(),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Main content stack.
                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading) {	
                        // Show the location information and time.
                        WeatherTopView(
                            model: model,
                            locationViewModel: locationViewModel,
                            shouldShowLocationSearch: $shouldShowLocationSearch
                        )
                        
                        Divider()
                            .overlay(.white)
                        
                        // Show weather summary.
                        WeatherSummaryView(model: model)
                        
                        // Show the temperature information
                        WeatherTemperatureView(model: model)
                        
                        // Show the other information.
                        WeatherCardView(model: model)
                        
                        // Show the source to the user.
                        WeatherSourceView()
                        
                        Divider()
                            .overlay(.white)
                        
                        // Show today's forecast hourly
                        WeatherHourlyView(model: model)
                        
                        Divider()
                            .overlay(.white)
                        
                        // Show the daily forcast.
                        WeatherDailyView(model: model)
                    }
                }
                .onAppear {
                    // Set the refresh progress view's color to white.
                    UIRefreshControl.appearance().tintColor = UIColor.white
                }
                .padding()
                .refreshable {
                    // Refresh the weather data.
                    await model.refreshAsync()
                }
                .navigationDestination(isPresented: $shouldShowLocationSearch) {
                    LocationView(model: locationViewModel, callback: locationUpdated)
                }
            }
        }
    }
    
    private func locationUpdated(latitude: Double, longitude: Double) {
        if model.getLatitude() != latitude || model.getLongitude() != longitude {
            model.update(latitude: latitude, longitude: longitude)
        }
    }
}

#Preview {
    WeatherView(model: WeatherViewModel(), locationViewModel: LocationViewModel())
}
