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

struct GradientColor {
    var colorPalette: [Color]
    var center: UnitPoint
    
    init(colorPalette: [Color], center: UnitPoint) {
        self.colorPalette = colorPalette
        self.center = center
    }
}
