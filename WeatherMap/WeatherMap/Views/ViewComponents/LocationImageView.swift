//
//  LocationImageView.swift
//  WeatherMap
//
//  Created by Wishal Dhiraj on 2024-01-08.
//

import SwiftUI

struct LocationImageView: View {
    let latitude: Double
    let longitude: Double
    
    // Set the image size (width x height)
    private let imageSize = "400x400"
    
    @State private var streetViewImage: UIImage?
    
    var body: some View {
        VStack {
            if let image = streetViewImage {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                
            }
        }
        .onAppear {
            loadImage()
        }
    }
    
    private func loadImage() {
        let urlString = "https://openstreetmap.org/cml?ml=streetview&layer=mapnik&style=default&lat=\(latitude)&lon=\(longitude)&zoom=14&mlat=\(latitude)&mlon=\(longitude)&width=\(imageSize)&height=\(imageSize)"
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                
                guard let data = data else {
                    print("Error: \(error?.localizedDescription ?? "Failed to decode data")")
                    
                    return
                }
                
                print(data)
                
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.streetViewImage = image
                    }
                } else {
                    print("Error: \(error?.localizedDescription ?? "Image parsing error")")
                }
            }.resume()
        }
    }
}

#Preview {
    LocationImageView(latitude: WeatherPresets.getDefaultLatitude(), longitude: WeatherPresets.getDefaultLongitude())
}
