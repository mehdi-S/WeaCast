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
            var main: Main?
            var description, icon: String?
            
            enum Main: String, Codable {
                case clear = "Clear"
                case clouds = "Clouds"
                case rain = "Rain"
            }
        }
        
        // MARK: - Wind
        struct Wind: Codable {
            var speed: Double?
            var deg: Int?
            var gust: Double?
        }
    }
}
