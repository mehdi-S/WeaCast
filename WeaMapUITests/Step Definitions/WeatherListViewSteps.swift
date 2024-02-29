//
//  WeatherListViewSteps.swift
//  WeaMapUITests
//
//  Created by Mehdi Silini on 29/02/2024.
//

import Foundation
import XCTest
import XCTest_Gherkin

final class AppointmentSteps: StepDefiner {
    let app = XCUIApplication()
    
    override func defineSteps() {
        let weatherListViewScreen = WeatherListViewScreen(app: self.app)
        
        self.defineWeatherListViewSteps(screen: weatherListViewScreen)
    }
    
    private func defineWeatherListViewSteps(screen: WeatherListViewScreen) {
        self.step("^I can see the forecast list$") {
            screen.forecastDaysList.waitForExistence(timeout: .medium)
        }
    }
}
