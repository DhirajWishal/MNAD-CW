//
//  DayWeatherView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct DayWeatherView: View {
    public let dayWeather: Day
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Set the background color.
                LinearGradient(
                    colors: WeatherPresets.getWeatherGradientColor(type: dayWeather.weather[0].main),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                // Display the information.
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        VStack {
                            Image(systemName: WeatherPresets.getWeatherSystemImage(type: dayWeather.weather[0].main))
                                .resizable()
                                .scaledToFit()
                                .frame(height: 100)
                                .foregroundStyle(.white.opacity(0.75))
                            
                            Text(dayWeather.weather[0].main)
                                .font(.largeTitle)
                                .foregroundStyle(.white.opacity(0.75))
                                .multilineTextAlignment(.leading)
                            
                            Text(dayWeather.weather[0].description.capitalized)
                                .foregroundStyle(.white.opacity(0.75))
                                .multilineTextAlignment(.leading)
                        }
                        
                        Text(dayWeather.summary)
                            .foregroundStyle(.white)
                            .font(.headline)
                            .multilineTextAlignment(.center)
                        
                        HStack(spacing: 20) {
                            VStack {
                                Text("Morning")
                                    .font(.title2)
                                    .foregroundStyle(.white.opacity(0.75))
                                    .bold()
                                
                                Text(WeatherViewModel.GetTemperature(temp: dayWeather.temp.morn))
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .bold()
                                
                                Text(WeatherViewModel.GetTemperature(temp: dayWeather.feelsLike.morn))
                                    .foregroundStyle(.white)
                            }
                            
                            VStack {
                                Text("Day")
                                    .font(.title2)
                                    .foregroundStyle(.white.opacity(0.75))
                                    .bold()
                                
                                Text(WeatherViewModel.GetTemperature(temp: dayWeather.temp.day))
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .bold()
                                
                                Text(WeatherViewModel.GetTemperature(temp: dayWeather.feelsLike.day))
                                    .foregroundStyle(.white)
                            }
                            
                            VStack {
                                Text("Evening")
                                    .font(.title2)
                                    .foregroundStyle(.white.opacity(0.75))
                                    .bold()
                                
                                Text(WeatherViewModel.GetTemperature(temp: dayWeather.temp.eve))
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .bold()
                                
                                Text(WeatherViewModel.GetTemperature(temp: dayWeather.feelsLike.eve))
                                    .foregroundStyle(.white)
                            }
                            
                            VStack {
                                Text("Night")
                                    .font(.title2)
                                    .foregroundStyle(.white.opacity(0.75))
                                    .bold()
                                
                                Text(WeatherViewModel.GetTemperature(temp: dayWeather.temp.night))
                                    .font(.title3)
                                    .foregroundStyle(.white)
                                    .bold()
                                
                                Text(WeatherViewModel.GetTemperature(temp: dayWeather.feelsLike.night))
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        VStack {
                            HStack {
                                WeatherInfoCard(
                                    systemName: "sunrise",
                                    title: "Sunrise", 
                                    content: WeatherViewModel.GetTime(unix: dayWeather.sunRise)
                                )
                                
                                WeatherInfoCard(
                                    systemName: "sunset",
                                    title: "Sunset", 
                                    content: WeatherViewModel.GetTime(unix: dayWeather.sunSet)
                                )
                            }
                            
                            HStack {
                                WeatherInfoCard(
                                    systemName: "humidity",
                                    title: "Humidity", 
                                    content: "\(dayWeather.humidity)%"
                                )
                                
                                WeatherInfoCard(
                                    systemName: "wind",
                                    title: "Wind", 
                                    content: "\(String(format: "%.1f", dayWeather.windGust!)) Km/h"
                                )
                            }
                            
                            HStack {
                                WeatherInfoCard(
                                    systemName: "water.waves",
                                    title: "Pressure", 
                                    content: "\(dayWeather.pressure) hPa"
                                )
                                
                                WeatherInfoCard(
                                    systemName: "sun.min",
                                    title: "UVI", 
                                    content: "\(dayWeather.uvi)"
                                )
                            }
                        }
                        .background(RoundedRectangle(cornerRadius: 20.0).fill(.white.opacity(0.1)))
                    }
                }
                .padding()
            }
            .navigationTitle(WeatherViewModel.GetDate(unix: dayWeather.dt))
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    DayWeatherView(
        dayWeather: WeatherViewModel().getDailyForecast()[0]
    )
}
