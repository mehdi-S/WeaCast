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
    var japanCoord: Coordinate = Coordinate(latitude: 35.6812546, longitude: 139.766706)
    var parisCoord: Coordinate = Coordinate(latitude: 48.790730, longitude: 2.511950)
    
    var defaultGradientColor = GradientColor(colorPalette: AppColors.dayColorPalette, center: .top)
    var actualGradientColor: GradientColor {
        if let weather = weatherState.value,
           let dt = weather.dt,
           let sunrise = weather.sys?.sunrise,
           let sunset = weather.sys?.sunset {
            return actualGradient(time: TimeInterval(dt), sunrise: TimeInterval(sunrise), sunset: TimeInterval(sunset))
        }
        return defaultGradientColor
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
    
    struct Coordinate {
        var latitude: Double
        var longitude: Double
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
    
    func actualGradient(time actual: TimeInterval, sunrise: TimeInterval, sunset: TimeInterval) -> GradientColor {
        let day: Double = 86400
        
        if actual >= sunrise && actual <= sunset {
            let base = actual - sunrise
            let tier = (base * 3) / (sunset - sunrise)
            
            switch tier {
            case let x where x <= 1:
                return GradientColor(colorPalette: AppColors.dayColorPalette, center: .topLeading)
            case let x where x <= 2:
                return GradientColor(colorPalette: AppColors.dayColorPalette, center: .top)
            case let x where x > 2:
                return GradientColor(colorPalette: AppColors.dayColorPalette, center: .topTrailing)
            default:
                fatalError("Should not happen")
            }
        }
        else if actual >= sunset {
            let base = actual - sunset
            let tier = (base * 3) / ((sunrise + day) - sunset)
            
            switch tier {
            case let x where x <= 1:
                return GradientColor(colorPalette: AppColors.nightColorPalette, center: .topLeading)
            case let x where x <= 2:
                return GradientColor(colorPalette: AppColors.nightColorPalette, center: .top)
            case let x where x > 2:
                return GradientColor(colorPalette: AppColors.nightColorPalette, center: .topTrailing)
            default:
                fatalError("Should not happen")
            }
        }
        else if actual <= sunrise {
            let base = actual - (sunset - day)
            let tier = (base * 3) / (sunrise - (sunset - day))
            
            switch tier {
            case let x where x <= 1:
                return GradientColor(colorPalette: AppColors.nightColorPalette, center: .topLeading)
            case let x where x <= 2:
                return GradientColor(colorPalette: AppColors.nightColorPalette, center: .top)
            case let x where x > 2:
                return GradientColor(colorPalette: AppColors.nightColorPalette, center: .topTrailing)
            default:
                fatalError("Should not happen")
            }
        }
        return self.defaultGradientColor
    }
}
