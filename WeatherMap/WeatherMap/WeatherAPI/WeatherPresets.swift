//
//  WeatherPresets.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import Foundation
import SwiftUI

enum WeatherType:Int, CaseIterable {
    case Thunderstorm = 0
    case Drizzle = 1
    case Rain = 2
    case Snow = 3
    case Atmosphere = 4
    case Clear = 5
    case Clouds = 6
}

struct WeatherPresets {
    public static let weatherTypeToString = [
        WeatherType.Thunderstorm:   "Thunderstorm",
        WeatherType.Drizzle:        "Drizzle",
        WeatherType.Rain:           "Rain",
        WeatherType.Snow:           "Snow",
        WeatherType.Atmosphere:     "Atmosphere",
        WeatherType.Clear:          "Clear",
        WeatherType.Clouds:         "Clouds"
    ]
    
    public static let weatherStringToType = [
        "Thunderstorm":             WeatherType.Thunderstorm,
        "Drizzle":                  WeatherType.Drizzle,
        "Rain":                     WeatherType.Rain,
        "Snow":                     WeatherType.Snow,
        "Atmosphere":               WeatherType.Atmosphere,
        "Clear":                    WeatherType.Clear,
        "Clouds":                   WeatherType.Clouds
    ]
    
    public static let weatherColorCodes = [
        WeatherType.Thunderstorm:   Color(red: 8 / 255, green: 54 / 255, blue: 86 / 255),
        WeatherType.Drizzle:        Color(red: 124 / 255, green: 142 / 255, blue: 135 / 255),
        WeatherType.Rain:           Color(red: 144 / 255, green: 153 / 255, blue: 161 / 255),
        WeatherType.Snow:           Color(red: 99 / 255, green: 133 / 255, blue: 146 / 255),
        WeatherType.Atmosphere:     Color(red: 0 / 255, green: 153 / 255, blue: 221 / 255),
        WeatherType.Clear:          Color(red: 33 / 255, green: 124 / 255, blue: 163 / 255),
        WeatherType.Clouds:         Color(red: 114 / 255, green: 157 / 255, blue: 158 / 255)
    ]
    
    public static let weatherTypeToSystemImage = [
        WeatherType.Thunderstorm:   "cloud.bolt",
        WeatherType.Drizzle:        "cloud.drizzle",
        WeatherType.Rain:           "cloud.heavyrain",
        WeatherType.Snow:           "cloud.snow",
        WeatherType.Atmosphere:     "cloud.fog",
        WeatherType.Clear:          "sun.min",
        WeatherType.Clouds:         "cloud.sun"
    ]
    
    public static func getColorList() -> [Color] {
        return weatherColorCodes.values.filter({ color in return true })
    }
    
    public static func getWeatherColor(type: WeatherType) -> Color {
        return WeatherPresets.weatherColorCodes[type] ?? .white
    }
    
    public static func getWeatherColor(type: String) -> Color {
        return WeatherPresets.getWeatherColor(type: WeatherPresets.weatherStringToType[type] ?? WeatherType.Thunderstorm)
    }
    
    public static func getWeatherGradientColor(type: WeatherType) -> [Color] {
        let color = WeatherPresets.weatherColorCodes[type] ?? .white
        return [ color, color.opacity(0.5) ]
    }
    
    public static func getWeatherGradientColor(type: String) -> [Color] {
        return WeatherPresets.getWeatherGradientColor(type: WeatherPresets.weatherStringToType[type] ?? WeatherType.Thunderstorm)
    }
    
    public static func getWeatherSystemImage(type: WeatherType) -> String {
        return WeatherPresets.weatherTypeToSystemImage[type] ?? ""
    }
    
    public static func getWeatherSystemImage(type: String) -> String {
        return getWeatherSystemImage(type: WeatherPresets.weatherStringToType[type] ?? WeatherType.Thunderstorm)
    }
    
    public static func getDefaultLatitude() -> Double {
        return 51.5072
    }
    
    public static func getDefaultLongitude() -> Double {
        return 0.1276
    }
}
