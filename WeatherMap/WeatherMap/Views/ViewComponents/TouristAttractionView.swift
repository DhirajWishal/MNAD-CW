//
//  TouristAttractionView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2024-01-09.
//

import SwiftUI

struct TouristAttractionView: View {
    let location: SubLocationDTO
    
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                VStack {
                    Link(location.name, destination: URL(string: location.link)!)
                        .font(.title)
                        .bold()
                    
                    Text(location.cityName)
                        .font(.title2)
                    
                    Text("(\(location.longitude), \(location.latitude))")
                        .opacity(0.5)
                }
                
                Spacer()
                
                Text(location.description)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                VStack {
                    ForEach(location.imageNames, id: \.self) { name in
                        Image(name)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: UIScreen.main.bounds.width)
                    }
                }
            }
            
            Spacer()
        }
        .padding()
        .ignoresSafeArea(edges: .bottom)
        .toolbarBackground(.hidden)
    }
}

#Preview {
    TouristAttractionView(location: SubLocationDTO(
        name: "Colosseum",
        cityName: "Rome",
        longitude: 41.8902,
        latitude: 12.4922,
        description: "The Colosseum is an oval amphitheatre...",
        imageNames: [
            "rome-colosseum-1",
            "rome-colosseum-2",
            "rome-colosseum-3"
        ],
        link: "https://en.wikipedia.org/wiki/Colosseum"
    )
    )
}
