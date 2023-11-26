//
//  WeatherTemperatureView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

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

#Preview {
    WeatherTemperatureView(model: WeatherViewModel())
}
