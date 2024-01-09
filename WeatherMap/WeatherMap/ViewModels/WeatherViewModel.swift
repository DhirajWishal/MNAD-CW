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
    private var provider = OpenWeatherMapProvider();
    private var weatherData: WeatherData? = nil
    
    private var latitude = WeatherPresets.getDefaultLatitude()
    private var longitude = WeatherPresets.getDefaultLongitude()
    
    init(dummyDataRequired: Bool? = nil) {
        guard let _ = dummyDataRequired else {
            loadData()
            return
        }
        
        loadWeatherData(useDummy: true)
    }
    
    public func getLatitude() -> Double {
        return latitude
    }
    
    public func getLongitude() -> Double {
        return longitude
    }
    
    public func update(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
        
        refresh()
    }
    
    public func refresh() {
        provider.getWeatherData(latitude: String(latitude), longitude: String(longitude), completion: onWeatherDataLoaded)
    }
    
    public func refreshAsync() async {
        await provider.getWeatherDataAsync(latitude: String(latitude), longitude: String(longitude), completion: onWeatherDataLoaded)
    }
    
    public func isDataLoaded() -> Bool {
        return weatherData != nil
    }
    
    public func loadWeatherData(useDummy: Bool = true) {
        if useDummy {
            provider.getDummyData(latitude: String(latitude), longitude: String(longitude), completion: onWeatherDataLoaded)
        }
        else {
            provider.getWeatherData(latitude: String(latitude), longitude: String(longitude), completion: onWeatherDataLoaded)
        }
    }
    
    public func getGradientColors(override: String? = nil) -> [Color] {
        guard let override = override else {
            guard let data = weatherData else { return WeatherPresets.getWeatherGradientColor(type: "") }
            return WeatherPresets.getWeatherGradientColor(type: data.current.weather[0].main)
        }
        
        return WeatherPresets.getWeatherGradientColor(type: override)
    }
    
    public func getSummary() -> String {
        guard let data = weatherData else { return "Loading..." }
        return data.current.weather[0].main
    }
    
    public func getDescription() -> String {
        guard let data = weatherData else { return "Loading..." }
        return data.current.weather[0].description.capitalized
    }
    
    public static func GetTime(unix: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"
        
        return formatter.string(from: date)
    }
    
    public static func GetHour(unix: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "h a"
        
        return formatter.string(from: date)
    }
    
    public static func GetDay(unix: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE dd"
        
        return formatter.string(from: date)
    }
    
    public static func GetDate(unix: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy"
        
        return formatter.string(from: date)
    }
    
    public static func GetDateTime(unix: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(unix))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' h a"
        
        return formatter.string(from: date)
    }
    
    public func getDateTime() -> String {
        guard let data = weatherData else { return "Jan 1, 1970 at 0 AM" }
        return WeatherViewModel.GetDateTime(unix: data.current.dt)
    }
    
    public func getSunRise() -> String {
        guard let data = weatherData else { return "0:00 AM" }
        return WeatherViewModel.GetTime(unix: data.current.sunRise)
    }
    
    public func getSunSet() -> String {
        guard let data = weatherData else { return "0:00 AM" }
        return WeatherViewModel.GetTime(unix: data.current.sunSet)
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
        guard let data = weatherData else { return "0 hPa" }
        return String(data.current.pressure) + " hPa"
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
        guard let data = weatherData else { return "0 Km/h" }
        return String(format: "%.1f", data.current.windSpeed) + " Km/h"
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
        
        latitude = data.lat
        longitude = data.lon
        
        saveData()
    }
    
    // Save data to local storage.
    public func saveData() {
        guard let data = weatherData else { return }
        if let encodedData = try? JSONEncoder().encode(data) {
            UserDefaults.standard.set(encodedData, forKey: "WeatherMap_WeatherData")
        }
    }
    
    // Load data from local storage.
    public func loadData() {
        let data = UserDefaults.standard.data(forKey: "WeatherMap_WeatherData")
        if let unwrappedData = data, let decodedData = try? JSONDecoder().decode(WeatherData.self, from: unwrappedData) {
            weatherData = decodedData
            
            latitude = decodedData.lat
            longitude = decodedData.lon
        }
    }
}
