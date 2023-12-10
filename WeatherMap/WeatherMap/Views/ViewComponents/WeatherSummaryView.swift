//
//  WeatherSummaryView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-12-10.
//

import SwiftUI

struct WeatherSummaryView: View {
    public let model: WeatherViewModel
    
    var body: some View {
        HStack {
            Image(systemName: WeatherPresets.getWeatherSystemImage(type: model.getSummary()))
                .resizable()
                .scaledToFit()
                .frame(height: 50)
                .foregroundStyle(.white.opacity(0.75))
            
            VStack(alignment: .leading) {
                Text(model.getSummary())
                    .font(.custom("ExtraLarge", size: 30))
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.leading)
                
                Text(model.getDescription())
                    .foregroundStyle(.white.opacity(0.75))
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

#Preview {
    WeatherSummaryView(model: WeatherViewModel())
}
