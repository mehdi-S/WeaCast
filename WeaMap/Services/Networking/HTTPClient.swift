//
//  HTTPClient.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import Foundation

enum NetworkError: Error {
    case badUrl
    case decodingError
    case invalidResponse
    case clientError
    case serverError
}

enum HttpMethod {
    case get([URLQueryItem]?)
    
    var name: String {
        switch self {
        case .get:
            return "GET"
        }
    }
}

struct Resource<T: Codable> {
    var url: URL
    var headers: [String: String] = [:]
    var method: HttpMethod = .get(nil)
}

class HTTPClient {
    func load<T: Codable>(_ resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        request.allHTTPHeaderFields = resource.headers
        request.httpMethod = resource.method.name
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: true)
            if let queryItems {
                components?.queryItems = queryItems
            }
            guard let url = components?.url else {
                throw NetworkError.badUrl
            }
            request.url = url
        }
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Content-Type": "application/json"]
        
        let session = URLSession(configuration: configuration)
        let (data, response) = try await session.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            print("✅ \(request.httpMethod!) \(request.url!) (code: \(httpResponse.statusCode))")
            break
        case 400...499:
            print("❌ \(request.httpMethod!) \(request.url!) (code: \(httpResponse.statusCode))")
            throw NetworkError.clientError
        case 500...599:
            print("❌ \(request.httpMethod!) \(request.url!) (code: \(httpResponse.statusCode))")
            throw NetworkError.serverError
        default:
            throw NetworkError.invalidResponse
        }
        
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch DecodingError.dataCorrupted(let context) {
            print("❌ \(context)")
            throw NetworkError.decodingError
        } catch DecodingError.keyNotFound(let key, let context) {
            print("❌ Key '\(key)' not found:", context.debugDescription)
            print("| codingPath:", context.codingPath)
            throw NetworkError.decodingError
        } catch DecodingError.valueNotFound(let value, let context) {
            print("❌ Value '\(value)' not found:", context.debugDescription)
            print("| codingPath:", context.codingPath)
            throw NetworkError.decodingError
        } catch DecodingError.typeMismatch(let type, let context) {
            print("❌ Type '\(type)' mismatch:", context.debugDescription)
            print("| codingPath:", context.codingPath)
            throw NetworkError.decodingError
        } catch {
            print("❌ error: ", error)
            throw NetworkError.decodingError
        }
    }
}
