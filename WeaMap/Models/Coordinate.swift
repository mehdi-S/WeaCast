//
//  Coordinate.swift
//  WeaMap
//
//  Created by Mehdi Silini on 28/02/2024.
//

import Foundation

struct Coordinate {
    var latitude: Double
    var longitude: Double
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    init(city: CityCoord) {
        switch city {
        case .tokyo:
            self.latitude = 35.6812546
            self.longitude = 139.766706
        case .paris:
            self.latitude = 48.790730
            self.longitude = 2.511950
        }
    }
}

enum CityCoord {
        case tokyo, paris
}
