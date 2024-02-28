//
//  Weather.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import Foundation

// MARK: - WeatherDTO
struct WeatherDTO: Codable {
    var coord: Coord?
    var weather: [Weather]?
    var base: String?
    var main: Main?
    var visibility: Int?
    var wind: Wind?
    var rain: Rain?
    var snow: Snow?
    var clouds: Clouds?
    var dt: Int?
    var sys: Sys?
    var timezone, id: Int?
    var name: String?
    var cod: Int?
    
    
    // MARK: - Clouds
    struct Clouds: Codable {
        var all: Int?
    }
    
    // MARK: - Coord
    struct Coord: Codable {
        var lon, lat: Double?
    }
    
    // MARK: - Main
    struct Main: Codable {
        var temp, feelsLike, tempMin, tempMax: Double?
        var pressure, humidity: Int?
    }
    
    // MARK: - Rain
    struct Rain: Codable {
        var the1H: Double?
    }
    
    // MARK: - Snow
    struct Snow: Codable {
        var the1H: Double?
    }
    
    // MARK: - Sys
    struct Sys: Codable {
        var type, id: Int?
        var country: String?
        var sunrise, sunset: Int?
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
    }
}

extension WeatherDTO {
    struct WeatherData: Identifiable, Hashable {
        var id: Self { self }
        var value: Double
        var unit: String?
        var description: String
        
        var dataDescription: String {
            [Int(self.value).description, self.unit].compactMap { $0 }.joined()
        }
    }
    
    var temperatureDisplayable: String {
        if let temp = self.main?.temp {
            return "\(Int(temp).description)°C"
        }
        return "--°C"
    }
    
    var sunriseDisplayable: String {
        return self.sys?.sunrise == nil ? "--:--" : TimeInterval(self.sys!.sunrise!).hourDisplayable
    }
    
    var sunsetDisplayable: String {
        return self.sys?.sunset == nil ? "--:--" : TimeInterval(self.sys!.sunset!).hourDisplayable
    }
    
    var numberOfDataItem: Int {
        (self.weather?.count ?? 0) + self.groupedWeatherData.count
    }
    
    var groupedWeatherData: [WeatherData] {
        var weatherDatas = [WeatherData]()
        
        if let mainWeatherData = self.main {
            if let humidity = mainWeatherData.humidity {
                weatherDatas.append(WeatherData(value: Double(humidity), unit: "%", description: "Humidity"))
            }
            if let pressure = mainWeatherData.pressure {
                weatherDatas.append(WeatherData(value: Double(pressure), unit: "hPa", description: "Pressure"))
            }
            if let tempMin = mainWeatherData.tempMin {
                weatherDatas.append(WeatherData(value: tempMin, unit: "°C", description: "Temp. Min"))
            }
            if let tempMax = mainWeatherData.tempMax {
                weatherDatas.append(WeatherData(value: tempMax, unit: "°C", description: "Temp. Max"))
            }
            if let feel = mainWeatherData.feelsLike {
                weatherDatas.append(WeatherData(value: feel, unit: "°C", description: "Temp. felt"))
            }
        }
        
        if let visibility {
            weatherDatas.append(WeatherData(value: Double(visibility), unit: "m", description: "Visibility"))
        }
        
        if let clouds = clouds?.all {
            weatherDatas.append(WeatherData(value: Double(clouds), unit: "%", description: "Clouds"))
        }
        
        if let rain = rain?.the1H {
            weatherDatas.append(WeatherData(value: Double(rain), unit: "mm", description: "Rain volume (1h)"))
        }
        
        if let snow = snow?.the1H {
            weatherDatas.append(WeatherData(value: Double(snow), unit: "mm", description: "Snow volume (1h)"))
        }
        
        return weatherDatas
    }
}
