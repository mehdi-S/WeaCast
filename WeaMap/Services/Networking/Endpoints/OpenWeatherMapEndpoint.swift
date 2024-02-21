//
//  OpenWeatherMapEndpoint.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import Foundation

fileprivate let apiKey = EnvironmentProperty.API_KEY

/// Endpoints for OpenWeatherMap API
enum WeatherEndpoint: EndpointProtocol {
    case getWeather(latitude: Double, longitude: Double)
    case getForecast(latitude: Double, longitude: Double)
    
    var baseURL: URL {
        Self.default
    }
    var absoluteURL: URL {
        switch self {
        case let .getWeather(latitude, longitude):
            return URL(string: "weather?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)", relativeTo: baseURL)!.absoluteURL
        case let .getForecast(latitude, longitude):
            return URL(string: "forecast?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)", relativeTo: baseURL)!.absoluteURL
        }
    }

    static var development: URL {
        URL(string: "https://api.openweathermap.org/data/2.5/")!
    }
    
    /// If we had any specific URL used for production environment
    static var production: URL {
        URL(string: "https://api.openweathermap.org/data/2.5/")!
    }
    
    /// return the correct URL base on the debug status of the app
    static var `default`: URL {
        #if DEBUG
            return development
        #else
            return production
        #endif
    }
}
