//
//  WeatherSourceView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-11-26.
//

import SwiftUI

struct WeatherSourceView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Source:")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Link(
                    "openweathermap.org",
                    destination: URL(string: "https://openweathermap.org")!
                )
                .font(.subheadline)
                .buttonStyle(.bordered)
                .tint(.white)
            }
        }
    }
}

#Preview {
    WeatherSourceView()
}
