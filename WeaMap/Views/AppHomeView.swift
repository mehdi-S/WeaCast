//
//  AppHomeView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 27/02/2024.
//

import SwiftUI

struct AppHomeView: View {
    @Environment(WeaMapModel.self) private var weaMapModel: WeaMapModel
    @State private var selectedData: DataModel?
    
    var body: some View {
        NavigationSplitView {
            WeatherListView()
                .environment(weaMapModel)
        } detail: {
            WeatherView()
                .environment(weaMapModel)
        }
    }
}

#Preview {
    AppHomeView().environment(WeaMapModel.shared)
}
