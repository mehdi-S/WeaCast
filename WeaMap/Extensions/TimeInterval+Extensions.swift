//
//  TimeInterval+Extensions.swift
//  WeaMap
//
//  Created by Mehdi Silini on 27/02/2024.
//

import Foundation

extension TimeInterval {
    func hourDisplayable(_ secondsFromGMT: Int = 0) -> String {
        let formatter = AppUtilities.dateFormatter
        formatter.dateFormat = "HH:mm"
        formatter.timeZone = TimeZone(secondsFromGMT: secondsFromGMT)
        let date = Date(timeIntervalSince1970: self)
        return formatter.string(from: date).description
    }
}
