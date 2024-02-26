//
//  WeatherView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import SwiftUI

struct WeatherView: View {
    
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
//            var testWeather = WeatherDTO(weather: [
//                WeatherDTO.Weather(id: 2, description: "test tes tes te", icon: "01d"),
//                WeatherDTO.Weather(id: 1, description: "test tes tes", icon: "02d"),
//                WeatherDTO.Weather(id: 3, description: "test tes tes", icon: "02d"),
//                WeatherDTO.Weather(id: 4, description: "test tes tes", icon: "02d"),
//                WeatherDTO.Weather(id: 5, description: "test tes tes", icon: "02d"),
//                WeatherDTO.Weather(id: 6, description: "test tes tes", icon: "02d")
//            ])
            LoadedView(data: weather)
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
        
        let columns = [
            GridItem(.adaptive(minimum: 90))
        ]
        
        ZStack {
            RadialGradient(colors: gradientColor.colorPalette,
                           center: gradientColor.center,
                           startRadius: 0,
                           endRadius: 250)
            .ignoresSafeArea()
            ScrollView {
                HStack(alignment: .center) {
                    Image(systemName: "location.circle.fill")
                        .symbolRenderingMode(.multicolor)
                    Text(weather.name ?? "can't find location")
                }
                Text(weather.main?.temp?.description ?? "")
                Text(weather.main?.feelsLike?.description ?? "")
                if let weatherConditions = weather.weather {
                    LazyVGrid(columns: columns) {
                        ForEach(weatherConditions, id: \.id) { condition in
                            WeatherConditionCard(weatherData: condition)
                        }
                    }
                }
                if let unix = weather.dt, let sunset = weather.sys?.sunset, let sunrise = weather.sys?.sunrise {
                    Text("time " + Date(timeIntervalSince1970: TimeInterval(unix) + Double(TimeZone.current.secondsFromGMT())).description)
                    Text("sunrise " + Date(timeIntervalSince1970: TimeInterval(sunrise) + Double(TimeZone.current.secondsFromGMT())).description)
                    Text("sunset " + Date(timeIntervalSince1970: TimeInterval(sunset) + Double(TimeZone.current.secondsFromGMT())).description)
                }
            }.padding(.horizontal, 16)
        }
    }
}

#Preview {
    WeatherView().environment(WeaMapModel.shared)
}
