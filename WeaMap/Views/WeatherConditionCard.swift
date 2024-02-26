//
//  WeatherConditionCard.swift
//  WeaMap
//
//  Created by Mehdi Silini on 25/02/2024.
//

import SwiftUI

struct WeatherConditionCard: View {
    var weatherData: WeatherDTO.Weather
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let iconId = weatherData.icon {
                AsyncImageBuilder(url: URL(string: "https://openweathermap.org/img/wn/\(iconId)@2x.png"))
                    .shadow(color: .black.opacity(0.3), radius: 6)
                    .background(.thinMaterial, in: Circle())
                    .padding(.top, 12)
                    .frame(maxHeight: .infinity)
            }
            Text(weatherData.description ?? "no description")
                .font(.headline)
                .minimumScaleFactor(0.4)
                .multilineTextAlignment(.center)
                .padding(4)
                .padding(.bottom, 8)
                .padding(.horizontal, 8)
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 120, maxHeight: 120)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 10,
                                                        style: .continuous)
        )
    }
}

#Preview {
    WeatherConditionCard(weatherData: WeatherDTO.Weather(id: 2, description: "test tes tes te", icon: "01d"))
}
