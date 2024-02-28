//
//  WeatherDisplayable.swift
//  WeaMap
//
//  Created by Mehdi Silini on 27/02/2024.
//

import Foundation

struct WeatherDisplayable: Identifiable, Hashable {
    var date: WeatherDate
    var locationTitle: String
    var header: HeaderDisplayable
    var imageDisplayable: [ImageDisplayable]
    var numberDisplayable: [NumberDisplayable]
    var gradientColor: GradientColor
    
    var id: Self { self }
    
    struct HeaderDisplayable: Hashable {
        var sunrise: ImageDisplayable
        var temperature: NumberDisplayable
        var sunset: ImageDisplayable
    }
    
    struct NumberDisplayable: Identifiable, Hashable {
        var id: Self { self }
        var value: Double
        var unit: String?
        var description: String
        
        var dataDescription: String {
            [Int(self.value).description, self.unit].compactMap { $0 }.joined()
        }
    }
    
    struct ImageDisplayable: Identifiable, Hashable {
        var id: Self { self }
        var value: ImageType
        var description: String
        
        enum ImageType: Hashable {
            case async(networkId: String)
            case system(systemId: String)
        }
        
        var imageURL: String {
            switch value {
            case .async(let networkId):
                return "https://openweathermap.org/img/wn/\(networkId)@2x.png"
            case .system(let systemId):
                return systemId
            }
        }
    }
    
    struct WeatherDate: Hashable {
        var index: Int
        var displayable: String {
            switch index {
            case let x where x == 0:
                return "Today"
            default:
                var dateComponent = DateComponents()
                dateComponent.day = index
                let formatter = AppUtilities.dateFormatter
                formatter.dateStyle = .long
                let futureDate = Calendar.current.date(byAdding: dateComponent, to: Date()) ?? Date().addingTimeInterval(TimeInterval(TimeZone.current.secondsFromGMT()) + (TimeInterval(86400) * Double(index)))
                return formatter.string(from: futureDate)
            }
        }
    }
    
    var numberOfColumnToDisplay: Int {
        (self.imageDisplayable.count + self.numberDisplayable.count) % 2 == 0 ? 2 : 3
    }
}

extension WeatherDisplayable {
    static var sample: WeatherDisplayable {
        WeatherDisplayable(date: WeatherDisplayable.WeatherDate(index: 0),
                           locationTitle: "The city",
                           header: WeatherDisplayable.HeaderDisplayable(sunrise: WeatherDisplayable.ImageDisplayable(value: .system(systemId: "sunrise.fill"),
                                                                                                                     description: "Sunrise"),
                                                                        temperature: WeatherDisplayable.NumberDisplayable(value: 12.0,
                                                                                                                          unit: "°C",
                                                                                                                          description: "Temperature"),
                                                                        sunset: WeatherDisplayable.ImageDisplayable(value: .system(systemId: "sunset.fill"),
                                                                                                                    description: "Sunset")),
                           imageDisplayable: [
                            WeatherDisplayable.ImageDisplayable(value: .async(networkId: "02d"),
                                                                description: "Cloudy")
                           ],
                           numberDisplayable: [
                            WeatherDisplayable.NumberDisplayable(value: 6, unit: "°C", description: "°C Min"),
                            WeatherDisplayable.NumberDisplayable(value: 14, unit: "°C", description: "°C Max"),
                            WeatherDisplayable.NumberDisplayable(value: 14, unit: "°C", description: "°C Felt"),
                            WeatherDisplayable.NumberDisplayable(value: 50, unit: "%", description: "Humidity"),
                            WeatherDisplayable.NumberDisplayable(value: 998, unit: "hPa", description: "Pressure"),
                            WeatherDisplayable.NumberDisplayable(value: 1200, unit: "m", description: "Visibility"),
                            WeatherDisplayable.NumberDisplayable(value: 20, unit: "%", description: "Cloudiness"),
                            WeatherDisplayable.NumberDisplayable(value: 32, unit: "mm", description: "Rain last 3h"),
                           ],
                           gradientColor: GradientColor(colorPalette: AppColors.dayColorPalette, center: .top)
        )
    }
}
