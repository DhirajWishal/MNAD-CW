//
//  WeatherPresets.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import Foundation
import SwiftUI

enum WeatherTypes:Int, CaseIterable {
    case Thunderstorm = 0
    case Drizzle = 1
    case Rain = 2
    case Snow = 3
    case Atmosphere = 4
    case Clear = 5
    case Clouds = 6
}

struct WeatherPresets {
    static let weatherColorCodes = [
        WeatherTypes.Thunderstorm: Color(red: 45 / 255, green: 54 / 255, blue: 86 / 255),
        WeatherTypes.Drizzle: Color(red: 140 / 255, green: 174 / 255, blue: 171 / 255),
        WeatherTypes.Rain: Color(red: 197 / 255, green: 226 / 255, blue: 247 / 255),
        WeatherTypes.Snow: Color(red: 99 / 255, green: 133 / 255, blue: 146 / 255),
        WeatherTypes.Atmosphere: Color(red: 0 / 255, green: 153 / 255, blue: 221 / 255),
        WeatherTypes.Clear: Color(red: 135 / 255, green: 203 / 255, blue: 222 / 255),
        WeatherTypes.Clouds: Color(red: 114 / 255, green: 157 / 255, blue: 158 / 255)
    ]
    
    static let weatherTypeToString = [
        WeatherTypes.Thunderstorm: "Thunderstorm",
        WeatherTypes.Drizzle: "Drizzle",
        WeatherTypes.Rain: "Rain",
        WeatherTypes.Snow: "Snow",
        WeatherTypes.Atmosphere: "Atmosphere",
        WeatherTypes.Clear: "Clear",
        WeatherTypes.Clouds: "Clouds"
    ]
    
    static let weatherStringToType = [
        "Thunderstorm": WeatherTypes.Thunderstorm,
        "Drizzle": WeatherTypes.Drizzle,
        "Rain": WeatherTypes.Rain,
        "Snow": WeatherTypes.Snow,
        "Atmosphere": WeatherTypes.Atmosphere,
        "Clear": WeatherTypes.Clear,
        "Clouds": WeatherTypes.Clouds
    ]
    
    public static func getColorList() -> [Color] {
        return weatherColorCodes.values.filter({ color in return true })
    }
    
    public static func getWeatherColor(type: WeatherTypes) -> Color {
        return WeatherPresets.weatherColorCodes[type] ?? .white
    }
    
    public static func getWeatherColor(type: String) -> Color {
        return WeatherPresets.getWeatherColor(type: WeatherPresets.weatherStringToType[type] ?? WeatherTypes.Thunderstorm)
    }
    
    public static func getWeatherGradientColor(type: WeatherTypes) -> [Color] {
        let color = WeatherPresets.weatherColorCodes[type] ?? .white
        return [ color, color.opacity(0.5) ]
    }
    
    public static func getWeatherGradientColor(type: String) -> [Color] {
        return WeatherPresets.getWeatherGradientColor(type: WeatherPresets.weatherStringToType[type] ?? WeatherTypes.Thunderstorm)
    }
}
