//
//  WeatherInfoCard.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct WeatherInfoCard: View {
    public let systemName: String
    public let title: String
    public let content: String
    
    var body: some View {
        HStack {
            Image(systemName: systemName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.white)
                .frame(width: 40, height: 40)
            
            Spacer()
            
            VStack {
                Text(title)
                    .foregroundStyle(.white)
                
                Text(content)
                    .font(.headline)
                    .foregroundStyle(.black.opacity(0.75))
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    WeatherInfoCard(systemName: "sun.min", title: "Sun", content: "Be chillin")
}
