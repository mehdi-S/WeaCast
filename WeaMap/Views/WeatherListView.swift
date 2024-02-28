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
    
    init(selectedDataBinding: Binding<WeatherDisplayable?>) {
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
                await weaMapModel.fetchForecast(coordinate: weaMapModel.parisCoord)
            }
        case .finished(let forecast):
            let datas = Array(0...4).compactMap { forecast.forDate(todayOffset: $0) }
                List(datas, selection: $selectedCellData) { item in
                    Section {
                        NavigationLink(item.date.displayable, value: item)
                    }
                }
        case .failed(let error):
            ErrorView(error: error, asyncOnTap: {
                await weaMapModel.fetchForecast(coordinate: weaMapModel.parisCoord)
            })
        }
    }
}

#Preview {
    WeatherListView(selectedDataBinding: .constant(WeatherDisplayable.sample))
        .environment(WeaMapModel.shared)
}
