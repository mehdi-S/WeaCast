//
//  AppColors.swift
//  WeaMap
//
//  Created by Mehdi Silini on 24/02/2024.
//

import SwiftUI

struct AppColors {
    static let dayColorPalette: [Color] = [Color(hex: 0xBCCEE5),
                                           Color(hex: 0xA5C1E5),
                                           Color(hex: 0x609BE5)]
    static let nightColorPalette: [Color] = [Color(hex: 0x5A5A98),
                                             Color(hex: 0x323164),
                                             Color(hex: 0x100F41)]
}

struct GradientColor: Hashable {
    var colorPalette: [Color]
    var center: UnitPoint
    
    
    
    init(colorPalette: [Color] = AppColors.dayColorPalette, center: UnitPoint = .top) {
        self.colorPalette = colorPalette
        self.center = center
    }
    
    init(for actual: TimeInterval, sunrise: TimeInterval, sunset: TimeInterval) {
        let day: Double = 86400
        
        if actual >= sunrise && actual <= sunset {
            let base = actual - sunrise
            let tier = (base * 3) / (sunset - sunrise)
            
            switch tier {
            case let x where x <= 1:
                self.colorPalette = AppColors.dayColorPalette
                self.center = .topLeading
            case let x where x <= 2:
                self.colorPalette = AppColors.dayColorPalette
                self.center = .top
            case let x where x > 2:
                self.colorPalette = AppColors.dayColorPalette
                self.center = .topTrailing
            default:
                fatalError("Should not happen")
            }
        }
        else if actual >= sunset {
            let base = actual - sunset
            let tier = (base * 3) / ((sunrise + day) - sunset)
            
            switch tier {
            case let x where x <= 1:
                self.colorPalette = AppColors.nightColorPalette
                self.center = .topLeading
            case let x where x <= 2:
                self.colorPalette = AppColors.nightColorPalette
                self.center = .top
            case let x where x > 2:
                self.colorPalette = AppColors.nightColorPalette
                self.center = .topTrailing
            default:
                fatalError("Should not happen")
            }
        }
        else if actual <= sunrise {
            let base = actual - (sunset - day)
            let tier = (base * 3) / (sunrise - (sunset - day))
            
            switch tier {
            case let x where x <= 1:
                self.colorPalette = AppColors.nightColorPalette
                self.center = .topLeading
            case let x where x <= 2:
                self.colorPalette = AppColors.nightColorPalette
                self.center = .top
            case let x where x > 2:
                self.colorPalette = AppColors.nightColorPalette
                self.center = .topTrailing
            default:
                fatalError("Should not happen")
            }
        }
        self.colorPalette = AppColors.dayColorPalette
        self.center = .top
    }
}
