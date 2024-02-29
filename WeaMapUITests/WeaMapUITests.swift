//
//  WeaMapUITests.swift
//  WeaMapUITests
//
//  Created by Mehdi Silini on 21/02/2024.
//

import XCTest
import SwiftUI
import XCTest_Gherkin

final class WeaMapUITests: XCTestCase {
    
    private var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
        self.app = XCUIApplication()
        self.app.launch()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testWeatherListView() throws {
        /// This is called Gherkin syntax
        /// https://support.smartbear.com/cucumberstudio/docs/bdd/write-gherkin-scenarios.html
        Given("I can see the forecast list")
        // then success !
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
