//
//  WeatherData.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import Foundation

struct WeatherData: Codable {
    let lat, lon: Double
    let timeZone: String
    let timeZoneOffset: Int
    let current: Current
    //    let minutely: [Minute]
    //    let hourly: [Hour]
    //    let daily: [Day]
    
    enum CodingKeys: String, CodingKey {
        case lat, lon
        case current
        //        case minutely
        //        case hourly
        //        case daily
        case timeZone = "timezone"
        case timeZoneOffset = "timezone_offset"
    }
}

struct Current: Codable {
    let dt, sunRise, sunSet: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDegree: Int
    let windGust: Double
    let weather: [Weather]
    
    enum CodingKeys: String, CodingKey {
        case dt, temp, pressure, humidity, uvi
        case clouds, visibility, weather
        case sunRise = "sunrise"
        case sunSet = "sunset"
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDegree = "wind_deg"
        case windGust = "wind_gust"
    }
}

struct Weather: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct Minute: Codable {
    let dt: Int
    let precipitation: Int
}

struct Hour: Codable {
    let dt: Int
    let temp, feelsLike: Double
    let pressure, humidity: Int
    let dewPoint, uvi: Double
    let clouds, visibility: Int
    let windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let pop: Double
    
    enum CodingKeys: String, CodingKey {
        case dt, temp, pressure, humidity, uvi
        case clouds, visibility, weather, pop
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
    }
}

struct Day: Codable {
    let dt, sunRise, sunSet, moonRise, moonSet: Int
    let moonPhase: Double
    let summary: String
    let temp: Temperature
    let feelsLike: FeelsLike
    let pressure, humidity: Int
    let dewPoint, windSpeed: Double
    let windDeg: Int
    let windGust: Double
    let weather: [Weather]
    let clouds, pop: Int
    let rain: Double
    let uvi: Int
    
    enum CodingKeys: String, CodingKey {
        case dt, summary, temp, pressure, humidity
        case weather, clouds, pop, rain, uvi
        case sunRise = "sunrise"
        case sunSet = "sunset"
        case moonRise = "moonrise"
        case moonSet = "moonset"
        case moonPhase = "moon_phase"
        case feelsLike = "feels_like"
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case windGust = "wind_gust"
    }
}

struct Temperature: Codable {
    let day: Double
    let min: Double
    let max: Double
    let night: Double
    let eve: Double
    let morn: Double
}

struct FeelsLike: Codable {
    let day: Double
    let night: Double
    let eve: Double
    let morn: Double
}
