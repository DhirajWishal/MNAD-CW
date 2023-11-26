//
//  WeatherViewModel.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import Foundation
import Observation
import SwiftUI

// TODO: Save the previous loaded JSON data and load them when opening the app.

@Observable class WeatherViewModel {
    var provider = OpenWeatherMapProvider();
    var weatherData: WeatherData? = nil
    
    var latitude = "6.9271"
    var longitude = "79.861244"
    
    init(dummyDataRequired: Bool? = nil) {
        guard let _ = dummyDataRequired else { return }
        loadWeatherData(latitude: latitude, longitude: longitude, useDummy: true)
    }
    
    public func refresh() async {
        await provider.getWeatherDataAsync(latitude: latitude, longitude: longitude, completion: onWeatherDataLoaded)
    }
    
    public func isDataLoaded() -> Bool {
        return weatherData != nil
    }
    
    public func loadWeatherData(latitude: String, longitude: String, useDummy: Bool = true) {
        if useDummy {
            provider.getDummyData(latitude: latitude, longitude: longitude, completion: onWeatherDataLoaded)
        }
        else {
            provider.getWeatherData(latitude: latitude, longitude: longitude, completion: onWeatherDataLoaded)
        }
    }
    
    public func getGradientColors(override: String? = nil) -> [Color] {
        guard let data = weatherData else { return WeatherPresets.getWeatherGradientColor(type: override ?? "") }
        return WeatherPresets.getWeatherGradientColor(type: data.current.weather[0].main)
    }
    
    public func getSummary() -> String {
        guard let data = weatherData else { return "Loading..." }
        return data.current.weather[0].main
    }
    
    public func getDescription() -> String {
        guard let data = weatherData else { return "Loading..." }
        return data.current.weather[0].description.capitalized
    }
    
    public static func GetHour(unix: Int) -> String {
        let date = NSDate(timeIntervalSince1970: Double(unix))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"
        
        return formatter.string(from: formatter.date(from: formatter.string(from: date as Date))!)
    }
    
    public static func GetDay(unix: Int) -> String {
        let date = NSDate(timeIntervalSince1970: Double(unix))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        
        return formatter.string(from: formatter.date(from: formatter.string(from: date as Date))!)
    }
    
    public func getDateTime() -> String {
        guard let data = weatherData else { return "Jan 1, 1970 at 00 AM" }
        let date = NSDate(timeIntervalSince1970: Double(data.current.dt))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' HH a"
        
        return formatter.string(from: formatter.date(from: formatter.string(from: date as Date))!)
    }
    
    public func getSunRise() -> String {
        guard let data = weatherData else { return "00:00\nAM" }
        return decodeTimeFromUnix(value: data.current.sunRise)
    }
    
    public func getSunSet() -> String {
        guard let data = weatherData else { return "00:00\nAM" }
        return decodeTimeFromUnix(value: data.current.sunSet)
    }
    
    public static func GetTemperature(temp: Double) -> String {
        return String(format: "%.1f", temp) + "°C"
    }
    
    public func getTemperature() -> String {
        guard let data = weatherData else { return "0°C" }
        return WeatherViewModel.GetTemperature(temp: data.current.temp)
    }
    
    public func getFeelsLikeTemperature() -> String {
        guard let data = weatherData else { return "0°C" }
        return String(format: "%.1f", data.current.feelsLike) + "°C"
    }
    
    public func getPressure() -> String {
        guard let data = weatherData else { return "0\nhPa" }
        return String(data.current.pressure) + "\nhPa"
    }
    
    public func getHumidity() -> String {
        guard let data = weatherData else { return "0%" }
        return String(data.current.humidity) + "%"
    }
    
    public func getUVI() -> String {
        guard let data = weatherData else { return "0" }
        return String(data.current.uvi)
    }
    
    public func getWind() -> String {
        guard let data = weatherData else { return "0\nKm/h" }
        return String(format: "%.1f", data.current.windSpeed) + "\nKm/h"
    }
    
    public func getHourlyForecast() -> [Hour] {
        guard let data = weatherData else { return [] }
        return data.hourly
    }
    
    public func getDailyForecast() -> [Day] {
        guard let data = weatherData else { return [] }
        return data.daily
    }
    
    private func onWeatherDataLoaded(data: WeatherData) {
        weatherData = data
    }
    
    private func decodeTimeFromUnix(value: Int) -> String {
        let date = NSDate(timeIntervalSince1970: Double(value))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm'\n'a"
        
        return formatter.string(from: formatter.date(from: formatter.string(from: date as Date))!)
    }
    
    // GUI helpers
    public static func getSystemImageFromMain(main: String) -> String {
        switch (main)
        {
        case "Thunderstorm":
            return "cloud.bolt"
            
        case "Drizzle":
            return "cloud.drizzle"
            
        case "Rain":
            return "cloud.heavyrain"
            
        case "Snow":
            return "cloud.snow"
            
        case "Atmosphere":
            return "cloud.fog"
            
        case "Clear":
            return "sun.min"
            
        case "Clouds":
            return "cloud"
            
        default:
            return ""
        }
    }
}
