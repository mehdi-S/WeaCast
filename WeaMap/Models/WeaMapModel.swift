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
    var weatherState: ResultState<WeatherDTO> = .idle
    var forecastState: ResultState<ForecastDTO> = .idle
    
    var actualGradientColor: GradientColor {
        if let weather = weatherState.value,
           let dt = weather.dt,
           let sunrise = weather.sys?.sunrise,
           let sunset = weather.sys?.sunset {
            return GradientColor(for: TimeInterval(dt), sunrise: TimeInterval(sunrise), sunset: TimeInterval(sunset))
        }
        return GradientColor()
    }
    
    enum ResultState<T: Codable> {
        case idle
        case loading
        case finished(T)
        case failed(Error)
        
        var value: T? {
            switch self {
            case .finished(let value):
                return value
            default:
                return nil
            }
        }
    }

    func testError() async {
        do {
            self.weatherState = .loading
            self.forecastState = .loading
            let _ = try await Task.sleep(nanoseconds: 1_000_000_000)
            self.weatherState = .failed(NetworkError.badUrl)
            self.forecastState = .failed(NetworkError.badUrl)
        } catch {
            self.weatherState = .failed(error)
        }
    }

    func fetchWeather(coordinate coord: Coordinate) async {
        let queryItems = [
            URLQueryItem(name: "lat", value: coord.latitude.description),
            URLQueryItem(name: "lon", value: coord.longitude.description),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        do {
            self.weatherState = .loading
            let result: WeatherDTO = try await client.load(Resource(url: WeatherEndpoint.getWeather.absoluteURL,
                                                                    method: .get(queryItems)))
            self.weatherState = .finished(result)
        } catch {
            self.weatherState = .failed(error)
        }
    }
    
    func fetchForecast(coordinate coord: Coordinate) async {
        let queryItems = [
            URLQueryItem(name: "lat", value: coord.latitude.description),
            URLQueryItem(name: "lon", value: coord.longitude.description),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]
        
        do {
            self.forecastState = .loading
            let result: ForecastDTO = try await client.load(Resource(url: WeatherEndpoint.getForecast.absoluteURL,
                                                                     method: .get(queryItems)))
            self.forecastState = .finished(result)
        } catch {
            self.forecastState = .failed(error)
        }
    }
}
