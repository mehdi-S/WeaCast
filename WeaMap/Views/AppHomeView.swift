//
//  AppHomeView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 27/02/2024.
//

import SwiftUI

struct AppHomeView: View {
    @Environment(WeaMapModel.self) private var weaMapModel: WeaMapModel
    @State private var selectedWeatherDisplayable: WeatherDisplayable?
    
    var body: some View {
        NavigationSplitView {
            WeatherListView(selectedDataBinding: $selectedWeatherDisplayable)
                .navigationTitle("Weather forecast")
        } detail: {
            if selectedWeatherDisplayable == nil || selectedWeatherDisplayable?.date.index == 0 {
                WeatherView()
                    .environment(weaMapModel)
                    .toolbarBackground(.ultraThinMaterial)
            } else {
                Text(selectedWeatherDisplayable?.header.temperature.dataDescription ?? "nil")
                    .toolbarBackground(.ultraThinMaterial)
            }
        }
    }
}

#Preview {
    AppHomeView().environment(WeaMapModel.shared)
}
