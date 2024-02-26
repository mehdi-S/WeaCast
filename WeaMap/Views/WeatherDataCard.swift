//
//  WeatherDataCard.swift
//  WeaMap
//
//  Created by Mehdi Silini on 26/02/2024.
//

import SwiftUI

struct WeatherDataCard: View {
    var weatherData: Double
    var unit: String?
    var description: String
    
    var textualData: String {
        [Int(weatherData).description, unit].compactMap { $0 }.joined()
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(textualData)
                .font(.title)
                .fontWeight(.bold)
                .minimumScaleFactor(0.6)
                .lineLimit(1)
                .shadow(color: .black.opacity(0.3), radius: 6)
                .padding(.horizontal, 14)
                .frame(maxHeight: .infinity)
                .padding(.top, 8)
            Text(description.capitalized)
                .font(.headline)
                .minimumScaleFactor(0.8)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .padding(4)
                .padding(.bottom, 8)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120, maxHeight: 120)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10,
                                                           style: .continuous)
        )
    }
}

#Preview {
    WeatherDataCard(weatherData: 139, unit: "hPa", description: "humidity")
}
