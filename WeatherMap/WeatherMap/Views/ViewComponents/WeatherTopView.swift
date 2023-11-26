//
//  WeatherTopView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct WeatherTopView: View {
    var model: WeatherViewModel
    @Binding var shouldShowLocationSearch: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("Location")
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)
                        .bold()
                    
                    Spacer()
                    
                    // Go to the location view if necessary.
                    Button(action: {
                        shouldShowLocationSearch = true
                    }, label: {
                        Image(systemName: "location.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 25, height: 25)
                            .tint(.white)
                    })
                }
                
                Text(model.getDateTime())
                    .bold()
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                
                Divider()
                    .background(.white)
                
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
    }
}

#Preview {
    WeatherTopView(model: WeatherViewModel(), shouldShowLocationSearch: .constant(false))
}
