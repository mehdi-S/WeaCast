//
//  WeatherListViewScreen.swift
//  WeaMapUITests
//
//  Created by Mehdi Silini on 29/02/2024.
//

import XCTest

struct WeatherListViewScreen: Screen {

    let app: XCUIApplication

    private enum Identifiers {
        static let forecastList = "forecast_days_list"
    }

    var forecastDaysList: XCUIElement {
        return self.app.scrollViews[Identifiers.forecastList]
    }
}
