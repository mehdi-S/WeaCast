//
//  WeaMapModel.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import SwiftUI

@Observable
@MainActor
class WeaMapModel {
    static let shared = WeaMapModel.init()
    
    let client = HTTPClient()
    var weather: WeatherDTO?
    
    func fetchWeather() async throws {
        self.weather = try await client.getWeather(url: WeatherEndpoint.getWeather(latitude: 35.6812546, longitude: 139.766706).absoluteURL)
    }
}
