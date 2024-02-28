//
//  Forecast.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import Foundation
import Algorithms

// MARK: - ForecastDTO
struct ForecastDTO: Codable {
    var cod: String?
    var message, cnt: Int?
    var list: [List]?
    var city: City?
    
    // MARK: - City
    struct City: Codable {
        var id: Int?
        var name: String?
        var coord: Coord?
        var country: String?
        var population, timezone, sunrise, sunset: Int?
        
        // MARK: - Coord
        struct Coord: Codable {
            var lat, lon: Double?
        }
    }
    
    // MARK: - List
    struct List: Codable {
        var dt: Int?
        var main: Main?
        var weather: [Weather]?
        var clouds: Clouds?
        var wind: Wind?
        var visibility: Int?
        var pop: Double?
        var rain: Rain?
        var sys: Sys?
        var dtTxt: String?
        
        // MARK: - Clouds
        struct Clouds: Codable {
            var all: Int?
        }
        
        // MARK: - MainClass
        struct Main: Codable {
            var temp, feelsLike, tempMin, tempMax: Double?
            var pressure, seaLevel, grndLevel, humidity: Int?
            var tempKf: Double?
        }
        
        // MARK: - Rain
        struct Rain: Codable {
            var the3H: Double?
        }
        
        // MARK: - Sys
        struct Sys: Codable {
            var pod: Pod?
            
            enum Pod: String, Codable {
                case d
                case n
            }
        }
        
        // MARK: - Weather
        struct Weather: Codable, Hashable {
            var description, icon: String
        }
        
        // MARK: - Wind
        struct Wind: Codable {
            var speed: Double?
            var deg: Int?
            var gust: Double?
        }
    }
}

extension ForecastDTO {
    func forDate(todayOffset offset: Int) -> WeatherDisplayable? {
        /// offset cannot go further than 4 days ahead
        guard offset <= 4, let daysData = self.list else {
            return nil
        }
        
        let selectedDayForecast: [ForecastDTO.List] = Array(daysData[offset*8...offset*8+7])
        
        var sunriseDisplayable: String {
            if let tzShift = self.city?.timezone, let sunriseUTC = self.city?.sunrise {
                return TimeInterval(sunriseUTC).hourDisplayable(tzShift)
            } else {
                return "--:--"
            }
        }
        
        var sunsetDisplayable: String {
            if let tzShift = self.city?.timezone, let sunsetUTC = self.city?.sunset {
                return TimeInterval(sunsetUTC).hourDisplayable(tzShift)
            } else {
                return "--:--"
            }
        }
        
        let humidity: Double = selectedDayForecast.compactMap{ $0.main?.humidity }.average
        let pressure: Double = selectedDayForecast.compactMap{ $0.main?.pressure }.average
        let temp: Double = selectedDayForecast.compactMap{ $0.main?.temp }.average
        let visibility: Double = selectedDayForecast.compactMap{ $0.visibility }.average
        let clouds: Double = selectedDayForecast.compactMap{ $0.clouds?.all }.average
        
        let weathers: [ForecastDTO.List.Weather] = Array(selectedDayForecast.compactMap { $0.weather }.joined().filter { $0.icon.contains("d") }.uniqued())        
        let weatherData = weathers.map{ WeatherDisplayable.ImageDisplayable(value: .async(networkId: $0.icon), description: $0.description) }
        
        var gradientColor: GradientColor {
            if let sunrise = self.city?.sunrise, let sunset = self.city?.sunset {
                return GradientColor(for: Date().timeIntervalSince1970, sunrise: TimeInterval(sunrise), sunset: TimeInterval(sunset))
            } else {
                return GradientColor()
            }
        }
        
        return WeatherDisplayable(date: WeatherDisplayable.WeatherDate(index: offset),
                                  locationTitle: self.city?.name ?? "no location found",
                                  header: WeatherDisplayable.HeaderDisplayable(sunrise: WeatherDisplayable.ImageDisplayable(value: .system(systemId: "sunrise.fill"),
                                                                                                                            description: sunriseDisplayable),
                                                                               temperature: WeatherDisplayable.NumberDisplayable(value: temp,
                                                                                                                                 unit: "°C",
                                                                                                                                 description: "Temperature"),
                                                                               sunset: WeatherDisplayable.ImageDisplayable(value: .system(systemId: "sunset.fill"),
                                                                                                                           description: sunsetDisplayable)),
                                  imageDisplayable: weatherData,
                                  numberDisplayable: [WeatherDisplayable.NumberDisplayable(value: humidity, unit: "%", description: "Humidity"),
                                                      WeatherDisplayable.NumberDisplayable(value: pressure, unit: "hPa", description: "Pressure"),
                                                      WeatherDisplayable.NumberDisplayable(value: visibility, unit: "m", description: "Visibility"),
                                                      WeatherDisplayable.NumberDisplayable(value: clouds, unit: "%", description: "Cloudiness"),
                                                     ],
                                  gradientColor: gradientColor)
    }
}
