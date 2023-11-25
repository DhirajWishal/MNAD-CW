//
//  WeatherView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-24.
//

import SwiftUI

struct WeatherView: View {
    var model: WeatherViewModel
    
    var body: some View {
        VStack(spacing: 50) {
            Text(model.getSummary())
                .font(.largeTitle)
                .bold()
                        
            Text(model.getDateTime())
                .bold()
                        
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Image(systemName: "globe")
                    Text("Sunsise at " + model.getSunRise())
                }
                
                HStack {
                    Image(systemName: "globe")
                    Text("Sunset at " + model.getSunSet())
                }
                
                HStack {
                    Image(systemName: "globe")
                    Text("Temperature is " + model.getTemperature())
                }
                
                HStack {
                    Image(systemName: "globe")
                    Text("Feels like " + model.getFeelsLikeTemperature())
                }
            }
            
            Spacer()
        }
    }
}

#Preview {
    WeatherView(model: WeatherViewModel())
}
