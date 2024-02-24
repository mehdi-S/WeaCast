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
            LoadedView(data: weather)
        case .failed(let error):
            ErrorView(error: error, asyncOnTap: {
                await weaMapModel.fetchWeather(coordinate: weaMapModel.parisCoord)
            })
        }
    }
    
    @ViewBuilder
    func LoadedView(data weather: WeatherDTO) -> some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(weather.name ?? "")
            Text(weather.main?.temp?.description ?? "")
        }
        .padding()
    }
}

#Preview {
    WeatherView().environment(WeaMapModel.shared)
}
