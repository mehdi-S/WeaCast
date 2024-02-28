//
//  WeaMapApp.swift
//  WeaMap
//
//  Created by Mehdi Silini on 21/02/2024.
//

import SwiftUI

@main
struct WeaMapApp: App {
    
    @State private var weaMapModel = WeaMapModel.shared
    
    var body: some Scene {
        WindowGroup {
            AppHomeView()
                .tint(.accentColor)
                .environment(weaMapModel)
        }
    }
}
