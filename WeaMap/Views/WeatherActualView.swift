//
//  WeatherActualView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import SwiftUI

struct WeatherActualView: View {
    
    @Environment(WeaMapModel.self) private var weaMapModel: WeaMapModel
    
    var body: some View {
        @State var state = weaMapModel.weatherState
        
        switch state {
        case .idle, .loading:
            VStack {
                LoadingView()
                    .delayAppearance(bySeconds: 1)
            }.task {
                await weaMapModel.fetchWeather(coordinate: weaMapModel.parisCoord)
            }
        case .finished(let weather):
            NavigationStack {
                LoadedView(data: weather)
            }
        case .failed(let error):
            ErrorView(error: error, asyncOnTap: {
                await weaMapModel.fetchWeather(coordinate: weaMapModel.parisCoord)
            })
        }
    }
    
    @MainActor
    @ViewBuilder
    func LoadedView(data weather: WeatherDTO) -> some View {
        @State var gradientColor: GradientColor = weaMapModel.actualGradientColor
        @State var columns = Array(repeating: GridItem(.flexible()),
                                   count: weather.numberOfDataItem % 2 == 0 ? 2 : 3)
        
        ZStack {
            RadialGradient(colors: gradientColor.colorPalette,
                           center: gradientColor.center,
                           startRadius: 0,
                           endRadius: 250)
            .ignoresSafeArea()
            ScrollView {
                VStack(spacing: 25) {
                    HStack(alignment: .center) {
                        Image(systemName: "location.circle.fill")
                            .symbolRenderingMode(.multicolor)
                        Text(weather.name ?? "can't find location")
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12,
                                                                    style: .continuous)
                    )
                    VStack(spacing: 15) {
                        MainWeatherTile(sunrise: weather.sunriseDisplayable,
                                        sunset: weather.sunsetDisplayable,
                                        temperature: weather.temperatureDisplayable)
                        if let weatherConditions = weather.weather {
                            LazyVGrid(columns: columns) {
                                ForEach(weatherConditions, id: \.id) { condition in
                                    WeatherConditionCard(weatherData: .remote(condition))
                                }
                                ForEach(weather.groupedWeatherData) { data in
                                    WeatherDataCard(weatherData: data.value, unit: data.unit, description: data.description)
                                }
                            }
                        }
                    }
                }
            }.padding(.horizontal, 16)
        }
    }
}

#Preview {
    WeatherActualView().environment(WeaMapModel.shared)
}
