//
//  OpenWeatherMapProvider.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import Foundation

class OpenWeatherMapProvider {
    let ApiKey = "61c5b091aed9a1d6b05e7757ec0ff575"
    
    /// Get weather data from the OpenWeatherMap API
    public func getWeatherData(latitude: String, longitude: String, completion: @escaping (WeatherData) -> Void) {
        guard let endpoint = getApiEndpoint(latitude: latitude, longitude: longitude) else { return }
        let task = URLSession.shared.dataTask(with: endpoint) { (data, response, error) in
            if let unwrappedData = data, let decodedData = try? JSONDecoder().decode(WeatherData.self, from: unwrappedData) {
                completion(decodedData)
            } else {
                print("Failed to decode the data!")
            }
        }
        
        task.resume()
    }
    
    /// Use this method for debugging.
    /// Calling the API too much might result in the service charging for each invokation.
    public func getDummyData(latitude: String, longitude: String, completion: @escaping (WeatherData) -> Void) {
        let dummyData = WeatherData(
            lat: Double(latitude) ?? 0,
            lon: Double(longitude) ?? 0,
            timeZone: "Asia/LK",
            timeZoneOffset: 0,
            current: Current(
                dt: 0,
                sunRise: 0,
                sunSet: 0,
                temp: 30,
                feelsLike: 40,
                pressure: 10,
                humidity: 1,
                dewPoint: 5,
                uvi: 1,
                clouds: 1,
                visibility: 1,
                windSpeed: 1,
                windDegree: 1,
                windGust: 1,
                weather: [
                    Weather(
                        id: 0,
                        main: "Cloudy",
                        description: "overcast clouds",
                        icon: "04n")
                ]
            )
        )
        
        completion(dummyData)
    }
    
    private func getApiEndpoint(latitude: String = "", longitude: String = "") -> URL? {
        let excludeList = "minutes,hours,daily,alerts"
        return URL(string: String("https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(ApiKey)&units=metric&exclude=\(excludeList)"))
    }
}
