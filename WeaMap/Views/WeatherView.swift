//
//  WeatherView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import SwiftUI

struct WeatherView: View {
    
    @Environment(WeaMapModel.self) private var weaMapModel: WeaMapModel?
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(weaMapModel?.weather?.name ?? "")
        }
        .padding()
        .task {
            do {
                try await weaMapModel?.fetchWeather()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

#Preview {
    WeatherView().environment(WeaMapModel.shared)
}
