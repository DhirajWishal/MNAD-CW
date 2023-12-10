//
//  WeatherCardView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct WeatherCardView: View {
    let weatherCardWidth: CGFloat = 110
    var model: WeatherViewModel
    
    var body: some View {
        VStack {
            HStack {
                WeatherInfoCard(systemName: "sunrise", title: "Sunrise", content: model.getSunRise())
                WeatherInfoCard(systemName: "sunset", title: "Sunset", content: model.getSunSet())
            }
            
            HStack {
                WeatherInfoCard(systemName: "humidity", title: "Humidity", content: model.getHumidity())
                WeatherInfoCard(systemName: "wind", title: "Wind", content: model.getWind())
            }
            
            HStack {
                WeatherInfoCard(systemName: "water.waves", title: "Pressure", content: model.getPressure())
                WeatherInfoCard(systemName: "sun.min", title: "UVI", content: model.getUVI())
            }
        }
        .background(RoundedRectangle(cornerRadius: 20.0).fill(.white.opacity(0.1)))
    }
}

#Preview {
    WeatherCardView(model: WeatherViewModel())
}
