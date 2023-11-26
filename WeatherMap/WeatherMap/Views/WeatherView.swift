//
//  WeatherView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import SwiftUI

struct WeatherTopView: View {
    var model: WeatherViewModel
    @Binding var shouldShowLocationSearch: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Location")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .bold()
                    
                    Spacer()
                    
                    // Go to the location view if necessary.
                    Button(action: {
                        shouldShowLocationSearch = true
                    }, label: {
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
                
                HStack {
                    Image(systemName: WeatherViewModel.getSystemImageFromMain(main: model.getSummary()))
                        .resizable()
                        .scaledToFit()
                        .frame(height: 50)
                        .foregroundStyle(.white.opacity(0.75))
                    
                    VStack(alignment: .leading) {
                        Text(model.getSummary())
                            .font(.custom("ExtraLarge", size: 30))
                            .foregroundStyle(.white.opacity(0.75))
                            .multilineTextAlignment(.leading)
                        
                        Text(model.getDescription())
                            .foregroundStyle(.white.opacity(0.75))
                            .multilineTextAlignment(.leading)
                    }
                }
            }
        }
    }
}

struct WeatherTemperatureView: View {
    var model: WeatherViewModel
    
    var body: some View {
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
    }
}

struct WeatherCardView: View {
    let weatherCardWidth: CGFloat = 110
    var model: WeatherViewModel
    
    var body: some View {
        HStack {
            Spacer()
            
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    VStack (spacing: 10) {
                        Label("Sunrise", systemImage: "sunrise")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: weatherCardWidth)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                        
                        Text(model.getSunRise())
                            .multilineTextAlignment(.center)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                    
                    VStack (spacing: 10) {
                        Label("Sunset", systemImage: "sunset")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: weatherCardWidth)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                        
                        Text(model.getSunSet())
                            .multilineTextAlignment(.center)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                    
                    VStack (spacing: 10) {
                        Text("UVI")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: weatherCardWidth)
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
                            .frame(width: weatherCardWidth)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                        
                        Text(model.getPressure())
                            .multilineTextAlignment(.center)
                    }
                    .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                    
                    VStack (spacing: 10) {
                        Label("Humidity", systemImage: "humidity")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: weatherCardWidth)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                        
                        Text(model.getHumidity())
                            .multilineTextAlignment(.center)
                            .lineLimit(2, reservesSpace: true)
                    }.background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                    
                    VStack (spacing: 10) {
                        Label("Wind", systemImage: "wind")
                            .font(.headline)
                            .foregroundStyle(.white)
                            .frame(width: weatherCardWidth)
                            .background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                        
                        Text(model.getWind())
                            .multilineTextAlignment(.center)
                            .lineLimit(2, reservesSpace: true)
                    }.background(RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0.25)).shadow(radius: 10))
                }
            }
            
            Spacer()
        }
    }
}

struct WeatherSourceView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Source")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button("openweathermap.org", action: {
                    onRedirectToSource()
                })
                .font(.subheadline)
                .buttonStyle(.bordered)
                .tint(.white)
            }
            
            Divider()
                .background(.white)
        }
    }
    
    private func onRedirectToSource() {
        if let url = URL(string: "openweathermap.org"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

struct WeatherHourlyView: View {
    var model: WeatherViewModel
    
    var body: some View {
        VStack {
            // TODO: See why the time is sus.
            ScrollView(.horizontal, showsIndicators: false) {
                HStack (spacing: 20) {
                    ForEach(model.getHourlyForecast()) { forecast in
                        VStack {
                            Text("\(WeatherViewModel.GetHour(unix: forecast.dt))")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.75))
                            
                            Text("\(WeatherViewModel.GetTemperature(temp: forecast.temp))")
                            Label("\(forecast.weather[0].main)", systemImage: WeatherViewModel.getSystemImageFromMain(main: forecast.weather[0].main))
                        }
                    }
                }
            }
            
            Divider()
                .background(.white)
        }
    }
}

struct WeatherDailyView: View {
    var model: WeatherViewModel
    
    var body: some View {
        ScrollView (showsIndicators: false) {
            VStack (spacing: 10) {
                ForEach(model.getDailyForecast()) { forecast in
                    NavigationLink (destination: {}) {
                        HStack {
                            Text("\(WeatherViewModel.GetDay(unix: forecast.dt))")
                                .font(.headline)
                                .foregroundStyle(.white.opacity(0.75))
                            
                            Spacer()
                            
                            Text("\(WeatherViewModel.GetTemperature(temp: forecast.temp.min)) / \(WeatherViewModel.GetTemperature(temp: forecast.temp.max))")
                            
                            Spacer()
                            
                            Image(systemName: WeatherViewModel.getSystemImageFromMain(main: forecast.weather[0].main))
                        }
                    }
                }
            }
        }
    }
}

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
