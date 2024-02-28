//
//  MainWeatherTile.swift
//  WeaMap
//
//  Created by Mehdi Silini on 26/02/2024.
//

import SwiftUI

struct MainWeatherTile: View {
    @State var sunrise: String
    @State var sunset: String
    @State var temperature: String
    
    var body: some View {
        LazyVGrid(columns: [GridItem(.flexible()),GridItem(.flexible()),GridItem(.flexible())]) {
            VStack {
                Image(systemName: "sunrise.fill")
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .shadow(color: .black.opacity(0.3), radius: 6)
                Text(sunrise)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
            }
            .padding()
            Text(temperature)
                .font(.system(size: 40))
                .fontWeight(.semibold)
            VStack {
                Image(systemName: "sunset.fill")
                    .symbolRenderingMode(.multicolor)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50)
                    .shadow(color: .black.opacity(0.3), radius: 6)
                Text(sunset)
                    .font(.system(size: 20))
                    .fontWeight(.semibold)
            }
            .padding()
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120, maxHeight: 120)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10,
                                                           style: .continuous)
        )
    }
}

#Preview {
    VStack {
        MainWeatherTile(sunrise: "12:32", sunset: "19:23", temperature: "32°C")
    }
    .ignoresSafeArea()
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.blue)
}
