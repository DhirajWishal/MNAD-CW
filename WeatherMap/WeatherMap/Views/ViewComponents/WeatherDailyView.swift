//
//  WeatherDailyView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct WeatherDailyView: View {
    public let model: WeatherViewModel
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack (spacing: 10) {
                ForEach(model.getDailyForecast()) { forecast in
                    NavigationLink (destination: {
                         DayWeatherView(dayWeather: forecast)
                    }) {
                        HStack {
                            Image(systemName: WeatherPresets.getWeatherSystemImage(type: forecast.weather[0].main))
                            
                            Spacer()
                            
                            Text("\(WeatherViewModel.GetDay(unix: forecast.dt))")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.75))
                            
                            Spacer()
                            
                            Text("\(WeatherViewModel.GetTemperature(temp: forecast.temp.min)) / \(WeatherViewModel.GetTemperature(temp: forecast.temp.max))")
                        }
                    }
                    .buttonStyle(.plain)
                    .frame(height: 40)
                }
            }
        }
    }
}

#Preview {
    WeatherDailyView(model: WeatherViewModel())
}
