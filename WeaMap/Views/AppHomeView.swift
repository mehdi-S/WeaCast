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
    private var coordinate = Coordinate(city: .paris)
    
    var body: some View {
        NavigationSplitView {
            WeatherListView(selectedDataBinding: $selectedWeatherDisplayable, coordinate: coordinate)
                .navigationTitle("Weather forecast")
        } detail: {
            if let displayable = selectedWeatherDisplayable, selectedWeatherDisplayable?.date.index != 0 {
                WeatherForecastView(weatherDisplayableBinding: Binding(
                    get: { selectedWeatherDisplayable ?? displayable },
                    set: { selectedWeatherDisplayable = $0 })
                )
                .toolbarBackground(.ultraThinMaterial)
                .navigationBarTitleDisplayMode(.inline)
            } else {
                WeatherActualView(coordinate: coordinate)
                    .environment(weaMapModel)
                    .toolbarBackground(.ultraThinMaterial)
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

#Preview {
    AppHomeView().environment(WeaMapModel.shared)
}
