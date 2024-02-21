//
//  HTTPClient.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case invalidResponse
    case decodingError
    case invalidServerResponse
    case invalidURL
}

class HTTPClient {
    func getWeather(url: URL) async throws -> WeatherDTO {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        guard let weatherDTO = try? JSONDecoder().decode(WeatherDTO.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return weatherDTO
    }
}
