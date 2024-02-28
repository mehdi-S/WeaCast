//
//  WeatherForecastView.swift
//  WeaMap
//
//  Created by Mehdi Silini on 28/02/2024.
//

import SwiftUI

struct WeatherForecastView: View {
    @Binding private var displayable: WeatherDisplayable
    
    init(weatherDisplayableBinding: Binding<WeatherDisplayable>) {
        self._displayable = weatherDisplayableBinding
    }
    
    var body: some View {
        @State var gradientColor: GradientColor = displayable.gradientColor
        @State var columns = Array(repeating: GridItem(.flexible()),
                                   count: displayable.numberOfColumnToDisplay)

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
                        Text(displayable.locationTitle)
                    }
                    .padding(.vertical, 4)
                    .padding(.horizontal, 6)
                    .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 12,
                                                                    style: .continuous)
                    )
                    VStack(spacing: 15) {
                        MainWeatherTile(sunrise: displayable.header.sunrise.description,
                                        sunset: displayable.header.sunset.description,
                                        temperature: displayable.header.temperature.dataDescription)
                        LazyVGrid(columns: columns) {
                            ForEach(displayable.imageDisplayable, id: \.id) { imageDisplayable in
                                WeatherConditionCard(weatherData: .local(imageDisplayable))
                            }
                            ForEach(displayable.numberDisplayable) { numberDisplayable in
                                WeatherDataCard(weatherData: numberDisplayable.value, unit: numberDisplayable.unit, description: numberDisplayable.description)
                            }
                        }
                    }
                }
            }.padding(.horizontal, 16)
        }
    }
}


#Preview {
    WeatherForecastView(weatherDisplayableBinding: .constant(WeatherDisplayable.sample))
}
