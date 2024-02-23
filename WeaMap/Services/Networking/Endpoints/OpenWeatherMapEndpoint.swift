//
//  OpenWeatherMapEndpoint.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import Foundation



/// Endpoints for OpenWeatherMap API
enum WeatherEndpoint: EndpointProtocol {
    case getWeather
    case getForecast
    
    var baseURL: URL {
        Self.default
    }
    var absoluteURL: URL {
        switch self {
        case .getWeather:
            return URL(string: "weather", relativeTo: baseURL)!.absoluteURL
        case .getForecast:
            return URL(string: "forecast", relativeTo: baseURL)!.absoluteURL
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
