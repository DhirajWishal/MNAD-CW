//
//  WeatherView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import SwiftUI

struct WeatherView: View {
    var model: WeatherViewModel
    
    @State var isRefreshing = false
    
    var body: some View {
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
                    HStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("Location")
                                    .font(.largeTitle)
                                    .foregroundStyle(.white)
                                    .multilineTextAlignment(.leading)
                                    .bold()
                                
                                Spacer()
                                
                                Button(action: {}, label: {
                                    Image(systemName: "location.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 25, height: 25)
                                        .tint(.white)
                                })
                            }
                            
                            Text(model.getDateTime())
                                .bold()
                                .foregroundStyle(.white)
                                .multilineTextAlignment(.leading)
                            
                            Divider()
                                .background(.white)
                            
                            Text(model.getSummary())
                                .font(.custom("ExtraLarge", size: 30))
                                .foregroundStyle(.white.opacity(0.75))
                                .multilineTextAlignment(.leading)
                            
                            Text(model.getDescription())
                                .foregroundStyle(.white.opacity(0.75))
                                .multilineTextAlignment(.leading)
                        }
                    }
                    
                    // Show the temperature information
                    HStack (spacing: 20) {
                        Text("\(model.getTemperature())")
                            .font(.custom("ExtraLarge", size: 50))
                            .foregroundStyle(.white)
                            .bold()
                        
                        Spacer()
                        
                        VStack(alignment: .trailing) {
                            Text("Feels like")
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(width: 90)
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                            
                            Text(model.getFeelsLikeTemperature())
                                .foregroundStyle(.white)
                        }
                    }
                    
                    // Show the other information.
                    HStack {
                        Spacer()
                        
                        VStack(alignment: .leading, spacing: 20) {
                            HStack {
                                VStack (spacing: 10) {
                                    Text("Sunrise")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(width: 100)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                    
                                    Text(model.getSunRise())
                                        .multilineTextAlignment(.center)
                                }
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                
                                VStack (spacing: 10) {
                                    Text("Sunset")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(width: 100)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                    
                                    Text(model.getSunSet())
                                        .multilineTextAlignment(.center)
                                }
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                
                                VStack (spacing: 10) {
                                    Text("UVI")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(width: 100)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                    
                                    Text(model.getUVI())
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2, reservesSpace: true)
                                }.background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                            }
                            
                            HStack(alignment:.top) {
                                VStack (spacing: 10) {
                                    Text("Pressure")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(width: 100)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                    
                                    Text(model.getPressure())
                                        .multilineTextAlignment(.center)
                                }
                                .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                
                                VStack (spacing: 10) {
                                    Text("Humidity")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(width: 100)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                    
                                    Text(model.getHumidity())
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2, reservesSpace: true)
                                }.background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                
                                VStack (spacing: 10) {
                                    Text("Wind")
                                        .font(.headline)
                                        .foregroundStyle(.white)
                                        .frame(width: 100)
                                        .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                                    
                                    Text(model.getWind())
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2, reservesSpace: true)
                                }.background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Divider()
                        .background(.white)
                    
                    // Show today's forecast hourly
                    // TODO: See why the time is sus.
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack (spacing: 20) {
                            ForEach(model.getHourlyForecast()) { forecast in
                                VStack {
                                    Text("\(WeatherViewModel.GetHour(unix: forecast.dt))")
                                        .font(.headline)
                                        .foregroundStyle(.white.opacity(0.75))
                                    
                                    Text("\(WeatherViewModel.GetTemperature(temp: forecast.temp))")
                                    Text("\(forecast.weather[0].main)")
                                }
                            }
                        }
                    }
                    
                    Divider()
                        .background(.white)
                    
                    // SHow the daily forcast.
                    ScrollView (showsIndicators: false) {
                        VStack (spacing: 10) {
                            ForEach(model.getDailyForecast()) { forecast in
                                HStack {
                                    Text("\(WeatherViewModel.GetDay(unix: forecast.dt))")
                                        .font(.headline)
                                        .foregroundStyle(.white.opacity(0.75))
                                    
                                    Spacer()
                                    
                                    Text("\(WeatherViewModel.GetTemperature(temp: forecast.temp.min)) / \(WeatherViewModel.GetTemperature(temp: forecast.temp.max))")
                                    
                                    Spacer()
                                    
                                    Text("\(forecast.weather[0].main)")
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            .refreshable {
                // Refresh the weather data.
                await model.refresh()
            }
        }
    }
}

#Preview {
    WeatherView(model: WeatherViewModel(dummyDataRequired: true))
}
