//
//  XCUIElement+Extensions.swift
//  WeaMapUITests
//
//  Created by Mehdi Silini on 29/02/2024.
//

import XCTest

extension XCUIElement {
    @discardableResult
    func waitForExistence(timeout: Timeout) -> Bool {
        return self.waitForExistence(timeout: timeout.rawValue)
    }

    @discardableResult
    func waitForElementToBecomeHittable(timeout: Timeout) -> Bool {
        return self.waitForExistence(timeout: timeout) && self.isHittable
    }
}
