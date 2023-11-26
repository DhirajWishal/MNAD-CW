//
//  WeatherHourlyView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct WeatherHourlyView: View {
    var model: WeatherViewModel
    
    var body: some View {
        VStack {
            // TODO: See hy the time is sus.
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 20) {
                    ForEach(model.getHourlyForecast()) { forecast in
                        VStack {
                            Text(WeatherViewModel.GetHour(unix: forecast.dt))
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.75))
                            
                            Text(WeatherViewModel.GetTemperature(temp: forecast.temp))
//                            Label(forecast.weather[0].main, systemImage: WeatherViewModel.getSystemImageFromMain(main: forecast.weather[0].main))
                            Text(forecast.weather[0].main)
                        }
                    }
                }
            }
            
            Divider()
                .background(.white)
        }
    }
}

#Preview {
    WeatherHourlyView(model: WeatherViewModel())
}
