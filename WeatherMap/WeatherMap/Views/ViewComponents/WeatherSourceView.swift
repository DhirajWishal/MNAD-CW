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
                Text("Source")
                    .font(.subheadline)
                    .foregroundStyle(.white)
                
                Spacer()
                
                Button("openweathermap.org", action: {
                    onRedirectToSource()
                })
                .font(.subheadline)
                .buttonStyle(.bordered)
                .tint(.white)
            }
        }
    }
    
    private func onRedirectToSource() {
        if let url = URL(string: "openweathermap.org"), UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    WeatherSourceView()
}
