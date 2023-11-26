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
            guard let unwrappedData = data else {
                print("Failed to unwrap data!")
                return
            }
            
            // Reference: https://stackoverflow.com/a/55391123/11228029
            do {
                let decodedData = try JSONDecoder().decode(WeatherData.self, from: unwrappedData)
                completion(decodedData)
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context)  {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch {
                print("error: ", error)
            }
        }
        
        task.resume()
    }
    
    /// Get weather data from the OpenWeatherMap API
    public func getWeatherDataAsync(latitude: String, longitude: String, completion: @escaping (WeatherData) -> Void) async {
        guard let endpoint = getApiEndpoint(latitude: latitude, longitude: longitude) else { return }
        
        // Reference: https://stackoverflow.com/a/55391123/11228029
        do {
            let (data, _) = try await URLSession.shared.data(from: endpoint)
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            completion(decodedData)
        } catch let DecodingError.dataCorrupted(context) {
            print(context)
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch let DecodingError.typeMismatch(type, context)  {
            print("Type '\(type)' mismatch:", context.debugDescription)
            print("codingPath:", context.codingPath)
        } catch {
            print("error: ", error)
        }
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
            ),
            hourly: [
                Hour(
                    dt: 0,
                    temp: 0,
                    feelsLike: 0,
                    pressure: 0,
                    humidity: 0,
                    dewPoint: 0,
                    uvi: 0,
                    clouds: 0,
                    visibility: 0,
                    windSpeed: 0,
                    windDeg: 0,
                    windGust: 0,
                    weather: [
                        Weather(
                            id: 0,
                            main: "Cloudy",
                            description: "overcast clouds",
                            icon: "04n")
                    ],
                    pop: 0),
                Hour(
                    dt: 0,
                    temp: 0,
                    feelsLike: 0,
                    pressure: 0,
                    humidity: 0,
                    dewPoint: 0,
                    uvi: 0,
                    clouds: 0,
                    visibility: 0,
                    windSpeed: 0,
                    windDeg: 0,
                    windGust: 0,
                    weather: [
                        Weather(
                            id: 0,
                            main: "Cloudy",
                            description: "overcast clouds",
                            icon: "04n")
                    ],
                    pop: 0)
            ],
            daily: [
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
                            main: "Cloudy",
                            description: "overcast clouds",
                            icon: "04n")
                    ],
                    clouds: 0,
                    pop: 0,
                    rain: 0,
                    uvi: 0
                )
            ]
        )
        
        completion(dummyData)
    }
    
    private func getApiEndpoint(latitude: String = "", longitude: String = "") -> URL? {
        let excludeList = "minutes,alerts"
        return URL(string: String("https://api.openweathermap.org/data/3.0/onecall?lat=\(latitude)&lon=\(longitude)&appid=\(ApiKey)&units=metric&exclude=\(excludeList)"))
    }
}
