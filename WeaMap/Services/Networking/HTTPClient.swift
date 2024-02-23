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

enum HttpMethod {
    case get([URLQueryItem])
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

struct Resource<T: Codable> {
    let url: URL
    let headers: [String: String] = [:]
    var method: HttpMethod = .get([])
}

class HTTPClient {
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        request.allHTTPHeaderFields = resource.headers
        request.httpMethod = resource.method.name
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: true)
            components?.queryItems = queryItems
            guard let url = components?.url else {
                throw NetworkError.badUrl
            }
            request.url = url
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        let session = URLSession(configuration: configuration)
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        guard let result = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}
