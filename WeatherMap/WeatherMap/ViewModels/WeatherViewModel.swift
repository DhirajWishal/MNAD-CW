//
//  WeatherViewModel.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import Foundation
import Observation
import CoreLocation

@Observable class WeatherViewModel {
    var provider = OpenWeatherMapProvider();
    var weatherData: WeatherData? = nil
    
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
    
    public func getSummary() -> String {
        guard let data = weatherData else { return "Loading..." }
        return data.current.weather[0].main
    }
    
    public func getDateTime() -> String {
        guard let data = weatherData else { return "Jan 1, 1970 at 00 AM" }
        let date = NSDate(timeIntervalSince1970: Double(data.current.dt))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, yyyy 'at' HH a"

        return formatter.string(from: formatter.date(from: formatter.string(from: date as Date))!)
    }
    
    public func getSunRise() -> String {
        guard let data = weatherData else { return "00:00 AM" }
        return decodeTimeFromUnix(value: data.current.sunRise)
    }
    
    public func getSunSet() -> String {
        guard let data = weatherData else { return "00:00 AM" }
        return decodeTimeFromUnix(value: data.current.sunSet)
    }
    
    public func getTemperature() -> String {
        guard let data = weatherData else { return "0°C" }
        return String(format: "%.1f", data.current.temp) + "°C"
    }
    
    public func getFeelsLikeTemperature() -> String {
        guard let data = weatherData else { return "0°C" }
        return String(format: "%.1f", data.current.feelsLike) + "°C"
    }
        
    private func onWeatherDataLoaded(data: WeatherData) {
        weatherData = data
    }
    
    private func decodeTimeFromUnix(value: Int) -> String {
        let date = NSDate(timeIntervalSince1970: Double(value))
        
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm a"

        return formatter.string(from: formatter.date(from: formatter.string(from: date as Date))!)
    }
}
