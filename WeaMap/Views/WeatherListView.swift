//
//  WeatherListView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 27/02/2024.
//

import SwiftUI

struct WeatherListView: View {
    @Environment(WeaMapModel.self) private var weaMapModel: WeaMapModel
    @Binding private var selectedCellData: WeatherDisplayable?
    private var coordinate: Coordinate

    init(selectedDataBinding: Binding<WeatherDisplayable?>, coordinate: Coordinate = Coordinate(city: .paris)) {
        self.coordinate = coordinate
        self._selectedCellData = selectedDataBinding
    }
    
    var body: some View {
        @State var state = weaMapModel.forecastState
        
        switch state {
        case .idle, .loading:
            VStack {
                LoadingView()
                    .delayAppearance(bySeconds: 1)
            }.task {
                await weaMapModel.fetchForecast(coordinate: coordinate)
            }
        case .finished(let forecast):
            let datas = Array(0...4).compactMap { forecast.forDate(todayOffset: $0) }
                List(datas, selection: $selectedCellData) { item in
                    Section {
                        NavigationLink(item.date.displayable, value: item)
                    }.accessibilityIdentifier("cell_section")
                }.accessibilityIdentifier("forecast_days_list")
        case .failed(let error):
            ErrorView(error: error, asyncOnTap: {
                await weaMapModel.fetchForecast(coordinate: coordinate)
            })
        }
    }
}

#Preview {
    WeatherListView(selectedDataBinding: .constant(WeatherDisplayable.sample))
        .environment(WeaMapModel.shared)
}
