//
//  WeatherListView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 27/02/2024.
//

import SwiftUI

struct WeatherListView: View {
    @Environment(WeaMapModel.self) private var weaMapModel: WeaMapModel
    
    var body: some View {
        @State var state = weaMapModel.forecastState
        
        switch state {
        case .idle, .loading:
            VStack {
                LoadingView()
                    .delayAppearance(bySeconds: 1)
            }.task {
                await weaMapModel.fetchForecast(coordinate: weaMapModel.parisCoord)
            }
        case .finished(let forecast):
            NavigationStack {
                Text(forecast.list?.first?.main?.temp?.description ?? "bite")
                //LoadedView(data: weather)
            }
        case .failed(let error):
            ErrorView(error: error, asyncOnTap: {
                await weaMapModel.fetchForecast(coordinate: weaMapModel.parisCoord)
            })
        }
    }
}

#Preview {
    WeatherListView().environment(WeaMapModel.shared)
}
