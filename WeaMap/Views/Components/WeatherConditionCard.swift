//
//  WeatherConditionCard.swift
//  WeaMap
//
//  Created by Mehdi Silini on 25/02/2024.
//

import SwiftUI

struct WeatherConditionCard: View {
    enum DataType {
        case remote(_ data: WeatherDTO.Weather)
        case local(_ data: WeatherDisplayable.ImageDisplayable)
    }
    
    var weatherData: DataType
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Group {
                switch weatherData {
                case .remote(let data):
                    AsyncImageBuilder(url: URL(string: "https://openweathermap.org/img/wn/\(data.icon ?? "")@2x.png"))
                case .local(let data):
                    switch data.value {
                    case .async(let networkId):
                        AsyncImageBuilder(url: URL(string: "https://openweathermap.org/img/wn/\(networkId)@2x.png"))
                    case .system(let systemId):
                        Image(systemName: systemId)
                    }
                }
            }
            .shadow(color: .black.opacity(0.3), radius: 6)
            .background(.thinMaterial, in: Circle())
            .padding(.top, 12)
            .frame(maxHeight: .infinity)
            
            Group {
                switch weatherData {
                case .remote(let data):
                    Text(data.description ?? "no description")
                case .local(let data):
                    Text(data.description)
                }
            }
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
    WeatherConditionCard(weatherData: .remote(WeatherDTO.Weather(id: 2, description: "test tes tes te", icon: "01d")))
}
