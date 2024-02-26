//
//  Environment.swift
//  WeaMap
//
//  Created by Mehdi Silini on 22/02/2024.
//

import SwiftUI

public enum EnvironmentProperty {
    enum Keys {
        static let apiKey = "API_KEY"
    }
    
    private static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else {
            fatalError("plist file not found")
        }
        return dict
    }()
    
    static let API_KEY: String = {
        guard let apiKeyString = EnvironmentProperty.infoDictionary[Keys.apiKey] as? String else {
            fatalError("API Key not set in plist")
        }
        return apiKeyString
    }()
}
