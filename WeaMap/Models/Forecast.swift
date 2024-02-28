//
//  Forecast.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import Foundation

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
        struct Weather: Codable {
            var id: Int?
            var main, description, icon: String?
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
        
        let sunriseDisplayable = self.city?.sunrise == nil ? "--:--" : TimeInterval(self.city!.sunrise!).hourDisplayable
        let sunsetDisplayable = self.city?.sunset == nil ? "--:--" : TimeInterval(self.city!.sunset!).hourDisplayable
        
        let humidity: Double = selectedDayForecast.compactMap{ $0.main?.humidity }.average
        let pressure: Double = selectedDayForecast.compactMap{ $0.main?.pressure }.average
        let temp: Double = selectedDayForecast.compactMap{ $0.main?.temp }.average
        let tempMin: Double = selectedDayForecast.compactMap{ $0.main?.tempMin }.average
        let tempMax: Double = selectedDayForecast.compactMap{ $0.main?.tempMax }.average
        let feelsLike: Double = selectedDayForecast.compactMap{ $0.main?.feelsLike }.average
        let visibility: Double = selectedDayForecast.compactMap{ $0.visibility }.average
        let rain3h: Double = selectedDayForecast.compactMap{ $0.rain?.the3H }.average
        let clouds: Double = selectedDayForecast.compactMap{ $0.clouds?.all }.average
        
        let weathers: [ForecastDTO.List.Weather] = Array(selectedDayForecast.compactMap { $0.weather }.joined())
        let mostCommonWeather = weathers.compactMap { $0.description }.mostCommonElement()
        let weatherIcon = weathers.first { $0.description == mostCommonWeather }?.icon
        let weatherIconDisplayable = weatherIcon == nil || weatherIcon!.isEmpty ? WeatherDisplayable.ImageDisplayable.ImageType.system(systemId: "") : WeatherDisplayable.ImageDisplayable.ImageType.async(networkId: weatherIcon!)
        
        
        let weatherData = WeatherDisplayable.ImageDisplayable(value: weatherIconDisplayable, description: mostCommonWeather)
        
        return WeatherDisplayable(date: WeatherDisplayable.WeatherDate(index: offset),
                                  locationTitle: self.city?.name ?? "no location found",
                                  header: WeatherDisplayable.HeaderDisplayable(sunrise: WeatherDisplayable.ImageDisplayable(value: .system(systemId: "sunrise.fill"),
                                                                                                                            description: sunriseDisplayable),
                                                                               temperature: WeatherDisplayable.NumberDisplayable(value: temp,
                                                                                                                                 unit: "°C",
                                                                                                                                 description: "Temperature"),
                                                                               sunset: WeatherDisplayable.ImageDisplayable(value: .system(systemId: "sunset.fill"),
                                                                                                                           description: sunsetDisplayable)),
                                  imageDisplayable: [weatherData],
                                  numberDisplayable: [WeatherDisplayable.NumberDisplayable(value: tempMin, unit: "°C", description: "°C Min"),
                                                      WeatherDisplayable.NumberDisplayable(value: tempMax, unit: "°C", description: "°C Max"),
                                                      WeatherDisplayable.NumberDisplayable(value: feelsLike, unit: "°C", description: "°C Felt"),
                                                      WeatherDisplayable.NumberDisplayable(value: humidity, unit: "%", description: "Humidity"),
                                                      WeatherDisplayable.NumberDisplayable(value: pressure, unit: "hPa", description: "Pressure"),
                                                      WeatherDisplayable.NumberDisplayable(value: visibility, unit: "m", description: "Visibility"),
                                                      WeatherDisplayable.NumberDisplayable(value: clouds, unit: "%", description: "Cloudiness"),
                                                      WeatherDisplayable.NumberDisplayable(value: rain3h, unit: "mm", description: "Rain last 3h"),
                                                     ])
    }
}
