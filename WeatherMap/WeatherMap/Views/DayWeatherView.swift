//
//  DayWeatherView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct DayWeatherView: View {
    let dayWeather: Day
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Set the background color.
                LinearGradient(
                    colors: WeatherViewModel.getWeatherGradientColor(main: dayWeather.weather[0].main),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Display the information.
                VStack {
                    Text(dayWeather.summary)
                }
            }
        }
    }
}

#Preview {
    DayWeatherView(
        dayWeather:
            Day(
                dt: 0,
                sunRise: 0,
                sunSet: 0,
                moonRise: 0,
                moonSet: 0,
                moonPhase: 0,
                summary: "Expect a day of partly cloudy with rain",
                temp: Temperature(
                    day: 0,
                    min: 0,
                    max: 0,
                    night: 0,
                    eve: 0,
                    morn: 0
                ),
                feelsLike: FeelsLike(
                    day: 0,
                    night: 0,
                    eve: 0,
                    morn: 0
                ),
                pressure: 0,
                humidity: 0,
                dewPoint: 0,
                windSpeed: 0,
                windDeg: 0,
                windGust: 0,
                weather: [
                    Weather(
                        id: 0,
                        main: "Clouds",
                        description: "overcast clouds",
                        icon: "04n")
                ],
                clouds: 0,
                pop: 0,
                rain: 0,
                uvi: 0
            )
    )
}
