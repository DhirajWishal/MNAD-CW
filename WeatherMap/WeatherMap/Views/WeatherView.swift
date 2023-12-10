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
                        WeatherTopView(model: model, shouldShowLocationSearch: $shouldShowLocationSearch)
                        
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
                    LocationView(latitude: model.getLatitude(), longitude: model.getLongitude(), callback: locationUpdated)
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
    WeatherView(model: WeatherViewModel())
}
