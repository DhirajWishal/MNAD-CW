//
//  WeatherHourlyView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI
import Charts

struct WeatherHourlyView: View {
    public let model: WeatherViewModel
    
    @Environment(\.colorScheme) private var colorScheme
    
    var body: some View {
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 20) {
                    ForEach(model.getHourlyForecast()) { forecast in
                        VStack {
                            Image(systemName: WeatherPresets.getWeatherSystemImage(type: forecast.weather[0].main))
                                .resizable()
                                .scaledToFit()
                                .frame(width: 40, height: 40)
                                .foregroundStyle(.white)
                            
                            Text(WeatherViewModel.GetTemperature(temp: forecast.temp))
                                .foregroundStyle(.white)
                            
                            Text(WeatherViewModel.GetHour(unix: forecast.dt))
                                .font(.headline)
                                .foregroundStyle(colorScheme == .dark ? .white.opacity(0.75) : .black.opacity(0.75))
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    WeatherHourlyView(model: WeatherViewModel())
}
