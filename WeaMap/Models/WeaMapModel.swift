//
//  WeaMapModel.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import SwiftUI

fileprivate let apiKey = EnvironmentProperty.API_KEY

@Observable
@MainActor
class WeaMapModel {
    static let shared = WeaMapModel.init()
    
    let client = HTTPClient()
    var weather: WeatherDTO?
    var forecast: ForecastDTO?

    func fetchWeather(latitude: Double, longitude: Double) async throws {
        let queryItems = [
            URLQueryItem(name: "lat", value: latitude.description),
            URLQueryItem(name: "lon", value: longitude.description),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        self.weather = try await client.load(Resource(url: WeatherEndpoint.getWeather.absoluteURL,
                                                      method: .get(queryItems)))
    }
    
    func fetchForecast(latitude: Double, longitude: Double) async throws {
        let queryItems = [
            URLQueryItem(name: "lat", value: latitude.description),
            URLQueryItem(name: "lon", value: longitude.description),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        self.forecast = try await client.load(Resource(url: WeatherEndpoint.getForecast.absoluteURL,
                                                      method: .get(queryItems)))
    }
}
