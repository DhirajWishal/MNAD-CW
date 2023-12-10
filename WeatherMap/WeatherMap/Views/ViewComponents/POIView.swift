//
//  POIView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2023-12-10.
//

import SwiftUI
import MapKit

struct POIView: View {
    public let mapItems: [MKMapItem]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            ForEach(mapItems, id: \.self) { result in
                if let name = result.name {
                    HStack {
                        VStack(alignment: .leading) {
                            if let url = result.url {
                                Button(action: {
                                    // Go-to link.
                                }, label: {
                                    Text(name)
                                        .multilineTextAlignment(.leading)
                                        .font(.headline)
                                })
                            }
                            else {
                                Text(name)
                                    .multilineTextAlignment(.leading)
                                    .font(.headline)
                            }
                            
                            if let phoneNumber = result.phoneNumber {
                                Text(phoneNumber)
                            }
                        }
                        
                        Spacer()
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    POIView(mapItems: [])
}
